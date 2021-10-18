task :set_target_ratios => :environment do
  hash = {
    'ryan@launchpadlab.com' => 0.25,
    'scott@launchpadlab.com' => 0.25,
    'adam@launchpadlab.com' => 0.5,
    'john@launchpadlab.com' => 0.5,
    'stephen@launchpadlab.com' => 0.5,
    'brett@launchpadlab.com' => 0.5,
    'matt@launchpadlab.com' => 0.75,
    'brady@launchpadlab.com' => 0.8,
    'conor@launchpadlab.com' => 0.83,
    'monique@launchpadlab.com' => 0.75,
    'ifat@launchpadlab.com' => 0.83,
    'brendan@launchpadlab.com' => 0.50,
    'rebecca@launchpadlab.com' => 0.0,
    'kelly@launchpadlab.com' => 0.0,
    'shannon@launchpadlab.com' => 0.0,
  }
  hash.each do |key, value|
    t = TeamMember.find_by(email: key)
    next unless t
    t.billable_target_ratio = value
    t.save
  end
end