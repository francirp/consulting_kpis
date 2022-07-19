module AsanaSync
  class TransformTask
    extend Memoist
    attr_reader :task_json

    def initialize(task_json)
      @task_json = task_json
    end

    def call
      {
        asana_id: task_json["gid"],
        name: task_json["name"],
        completed_on: completed_on,
        due_on: due_on,
        created_at: created_at,
        updated_at: updated_at,
        size: size,
        dev_days: dev_days,
        unit_type: unit_type,
      }
    end

    private

    def due_on
      value = task_json.dig("due_on")
      parse_date(value)
    end

    def completed_on
      value = task_json.dig("completed_at")
      parse_date(value) # no need to get timestamp, just need date
    end

    def created_at
      value = task_json.dig("created_at")
      parse_datetime(value)
    end

    def updated_at
      value = task_json.dig("modified_at")
      parse_datetime(value)
    end    

    def parse_date(string)
      Date.parse(string) if string
    end 
    
    def parse_datetime(string)
      DateTime.parse(string) if string
    end     

    def estimation_field
      task_json["custom_fields"].detect { |c| c["enabled"] && is_estimation_field?(c) }
    end

    def is_estimation_field?(field)
      name = field["name"].downcase
      ["hour", "days", "point"].any? { |keyword| name.include?(keyword) }
    end

    def size
      return nil unless estimation_field
      estimation_field["number_value"]
    end
    
    def dev_days
      return nil unless size
      return size if ["dev_days", "points"].include?(unit_type)
      return size / 6.0 if unit_type == "hours"
    end

    def unit_type
      return nil unless estimation_field
      name = estimation_field["name"].downcase
      return "hours" if name.include?("hour") 
      return "dev_days" if name.include?("days")
      return "points" if name.include?("point") 
      nil
    end
    memoize :unit_type
  end
end