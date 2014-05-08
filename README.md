# Inscriptio

## Project Description

Inscriptio is a web-based system intended to help manage the reservation of carrels and other reservable library assets with defined locations.

## System Requirements

### General
* Ruby 1.9.3+ (2.x preferred)
* Bundler
* PostgreSQL 9.x+
* A webserver capable of interfacing with Rails applications. Ideally, Apache or Nginx with mod_passenger installed
* Linux or OSX
* ImageMagick

### Development/Test
* In order to run the test suite, you will need to install PhantomJS (http://phantomjs.org/)

## Application Set-up Steps

1. Get code from: https://github.com/harvard-library/Inscriptio
2. Run bundle install. You will probably have to install OS-vendor supplied libraries to satisfy some gem install requirements.
3. Create the database and run `rake db:schema:load`, after modifying "config/database.yml" to suit your environment.
4. Create a .env file for your environment. Currently, the following variables are needed to run Inscriptio:

  ```
  SECRET_TOKEN=30+charstringofrandomnessgottenfromrakesecretmaybe #Only needed in RAILS_ENV=production
  DEVISE_SECRET_KEY=30+charstringDifferentFromAbove               #Also only needed in RAILS_ENV=production
  INSCRIPTIO_ROOT=my.inscriptio.host.com
  INSCRIPTIO_MAIL_SENDER=email.address.for.mails@my.inscriptio.host.com
  ```
5. Run bootstrap rake tasks:

  ```Shell
   rake inscriptio:bootstrap:run_all
   rake inscriptio:cron_task:setup_crontab
  ```
This populates the instance with some necessary basic items, and creates several cron tasks which manage the reservation lifecyle and delete old posts from bulletin boards.

## Order of Operations for Fresh Install

1. Sign in as admin
2. Create User Types
3. Create School Affiliations
4. Create library
5. Create floors
6. Create asset types
7. Upload/create assets (for upload you will need floor and asset types ID's)
8. Add assets to floor map (remember to hit 'Apply' button to save asset on map)
9. Go to 'Reservation Notices' section and alter Notices as desired.

## Capistrano

Deployment is beyond the scope of this README, and generally site-specific.  There are example capistrano deployment files that reflect deployment practice at Harvard.

Some basic notes:
* The example files are written with this environment in mind:
  * Capistrano 3+
  * A user install of RVM for ruby management
* Arbitrary rake tasks can be run remotely via the `deploy:rrake` task. Syntax is `cap $STAGE deploy:rrake T=$RAKE_TASK`.  So, to run `rake inscriptio:bootstrap` in the `qa` deploy environment, do:

  ```Shell
  cap qa deploy:rrake T=inscriptio:bootstrap
  ```

## Additional Dev Notes

Additional development notes can be found [here](DEV_NOTES.md)

## Contributing

If you've found a problem with Inscriptio, or have a suggestion for a feature, please create an issue.  If you have a fix or enhancement that's general enough to be useful to someone else, please submit a pull request.

### Wishlist

If you'd like to help improve Inscriptio, but aren't sure where to start, here are a few places we could really use some love:

* Unit tests (Everyone loves writing tests, right?)
* Making some of the presentation layer themeable (logo, colors, etc)
* Replacing NicEdit with something more modern
* Smarter handling of static content per instance (currently handled by the Message class) would be nice.

These are just the tip of the iceberg - there's plenty of work to go around ;-)

## Contributors

* Justin Clark: http://github.com/jdcc
* Daniel Collis-Puro: http://github.com/djcp
* Dave Mayo: http://github.com/pobocks
* Anita Patel: http://github.com/apatel

## License and Copyright

This application is released under a GPLv3 license.

2011 President and Fellows of Harvard College
