class AdminController < ApplicationController

  layout "admin"

  # TODO uncomment for production ENDTODO http_basic_authenticate_with name: ENV.fetch('ADMIN_NAME', 'admin'),
  # TODO uncomment for production ENDTODO                              password: ENV.fetch('ADMIN_PASSWORD', 'password')

end
