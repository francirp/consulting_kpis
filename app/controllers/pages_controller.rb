class PagesController < ApplicationController

  def home
    @clients = Client.includes(:projects).all
  end

end
