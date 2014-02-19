# Inscriptio

## Project Description

Inscriptio is a web-based system intended to help manage the reservation of carrels and other reservable library assets with defined locations.

## System Requirements

### General
* Ruby 1.9.3 and a bunch of gems included in the Gemfile
* A postgresql 9.x+ database server.
* A webserver capable of interfacing with Rails applications. Ideally, apache or nginx with mod_passenger installed.
* Linux or OSX.
* ImageMagick

### Development/Test
* In order to run the test suite, you will need to install PhantomJS (http://phantomjs.org/)

## Application Set-up Steps

1. Get code from: https://github.com/harvard-library/Inscriptio
2. Run bundle install. You will probably have to install OS-vendor supplied libraries to satisfy some gem install requirements.
3. Create the database and run rake , modifying "config/database.yml" to suit your environment.
4. Create a .env file for your environment. Currently, the following variables are needed to run Inscriptio:

```
SECRET_TOKEN=30+charstringofrandomnessgottenfromrakesecretmaybe #Only needed in RAILS_ENV=production
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
2. Create User Types (may change once PIN is in)
3. Create School Affiliations (may change once PIN is in)
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

## Contributors

* Daniel Collis-Puro: http://github.com/djcp
* Anita Patel: http://github.com/apatel
* Justin Clark: http://github.com/jdcc
* Dave Mayo: http://github.com/pobocks

## License and Copyright

This application is released under a GPLv3 license.

2011 President and Fellows of Harvard College
