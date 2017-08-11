TicketFinders
=============

Getting Started
---------------

Make sure you have Ruby version 2.0.0 installed.
Recommend to use [RVM](https://rvm.io/).

You will need [ImageMagick](https://www.imagemagick.org/) installed.

The application uses PostgreSQL. Versions 8.2 and up are supported.
Create database and config file `config/database.yml` for connection.
File example:

    default: &default
      adapter: postgresql
      encoding: unicode
      pool: 5
      host: localhost
      username: tfbase
      password: <%= ENV['APP_DATABASE_PASSWORD'] %>

    development:
      <<: *default
      database: tfbase_development

    test:
      <<: *default
      database: tfbase_test

    production:
      <<: *default
      database: tfbase_production
      username: rails
      password: <%= ENV['APP_DATABASE_PASSWORD'] %>

Also you need to create `config/application.yml` file to set env. variables:

    ADMIN_NAME: "admin"
    ADMIN_PASSWORD: "password"

    # Secret key (for secrets.yml)
    SECRET_KEY_BASE: "bb9f009fb3fd28b15c5313b91c49978d70cc97067e61b58dfffba2814f54cf49eb0105615f27b7ba0bd96b6ac46c7ee0a23ac44bceeb9580e604d41dbdda5acc"

    # Login info for Gmail SMTP settings
    GMAIL_USER: "user@gmail.com"
    GMAIL_PASSWORD: "password"

    # PSQL password (corresponds with database.yml credentials)
    APP_DATABASE_PASSWORD: "password"

    # Deploy variables
    DEPLOY_DOMAIN: "<server domain or IP address>"
    DEPLOY_TO: "<path to the application directory on the server>"
    DEPLOY_USER: "<username in the server to SSH to>"

When done, run:

    $ bin/bundle install --without production
    $ bin/rake db:create db:migrate

Install demo data using command: `bin/rake db:seed` if you need.

Application ready for start. You can launch webserver with
command `bin/rails server` and see home page
at [localhost:3000](http://localhost:3000/) url.


Project life cycle
------------------

### Adding new routes

Add the new route to the 'config/sitemap.xml' file.


Deploy
------

Run deploy with command `mina deploy`.
Restart Unicorn manually (under root) after mina finish her job. (TODO)

Before the first deploy to server you'll need to run 'mina setup'.
Also you'll need create files 'database.yml' and 'application.yml' with correct
credentials in 'shared/config' directory on the server.


Previous notes
--------------

### A few things to check before deploying to remote machine

> Login to server from terminal

`ssh root@ip`

> Copy & Replace **/config/database.yml** & **/config/application/yml** with pre-completed file from **/home/rails** or just copy working files from old version of app.

<!-- -->
> Bundle install inside the new folder

`bundle`

> Bundle update

`bundle update`

> Precompile assets

*DB dump and create is Deprecated*

> Sometimes it's necessary to drop & reseed the database, here's how to do it

> Change user to rails (database administrator)

`su - rails`

> Start PostgreSQL with `psql`

<!-- -->
> Check for current users accessing the database

`SELECT * FROM pg_stat_activity;`

> Take note of **pid** number from results, then kill as needed

`SELECT pg_terminate_backend(pid_int);`

> Switch user back into root

`su - root`

> Navigate to app folder and drop database

`RAILS_ENV=production rake db:drop`

> Then run the following commands (in order) to create, migrate & seed the database

`RAILS_ENV=production rake db:create`
`RAILS_ENV=production rake db:migrate`
`RAILS_ENV=production rake db:seed`

> Precompile assets with this command

`RAILS_ENV=production rake assets:precompile`

> Ensure root app folder is owned by rails user

`chown -R rails: /home/rails/ticketfinders1/`

<!-- -->
> Give read-write permissions to **tmp/cache**

`chmod -R 0777 cache/`

<!-- -->
> **Troubleshoot** in root/log/production.log

`tail -f /home/rails/ticketfinders1/log/production.log`

> Further helpful resources

<!-- -->
> Restart Unicorn & Reload NGINX

<!-- -->
>[Ruby on Rails Digital Ocean deployment](https://www.digitalocean.com/community/tutorials/how-to-use-the-ruby-on-rails-one-click-application-on-digitalocean "Title")
