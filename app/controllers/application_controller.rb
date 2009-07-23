# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  before_filter :verify, :only => [:create, :edit, :update, :destroy, :new]

  def verify
    authenticate_or_request_with_http_basic("IEEMA Rising Sun Admin") do |username,password|
      username == ADMIN_USERNAME && password == ADMIN_PASSWORD
    end
  end

end
