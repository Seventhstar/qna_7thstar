require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  protect_from_forgery with: :exception
  before_action :gon_user

  respond_to :html

  private  
    def gon_user
      gon.current_user = current_user if current_user
    end
end
