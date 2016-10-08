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
