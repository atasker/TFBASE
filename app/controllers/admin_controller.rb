class AdminController < ApplicationController

  layout "admin"

  http_basic_authenticate_with name: "adam", password: "password"

end
