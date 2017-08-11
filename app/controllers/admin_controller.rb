class AdminController < ApplicationController

  layout "admin"

  http_basic_authenticate_with name: ENV.fetch('ADMIN_NAME', 'admin'),
                               password: ENV.fetch('ADMIN_PASSWORD', 'password')

end
