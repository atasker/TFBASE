class AdminController < ApplicationController

  layout "admin"

  http_basic_authenticate_with name: ENV["ADMIN_NAME"], password: ENV["ADMIN_PASSWORD"]

end
