# Inscriptio

## Project Description

Inscriptio is a web-based system intended to help manage the reservation of carrels and other reservable library assets with defined locations.

## System Requirements

* Ruby 1.9.3 and a bunch of gems included in the Gemfile
* A postgresql 8.x+ database server.
* A webserver capable of interfacing with Rails applications. Ideally, apache or nginx with mod_passenger installed.
* Linux or OSX. Linux would be easier.

## Application Set-up Steps

1. Get code from: https://github.com/berkmancenter/Inscriptio
2. Run bundle install. You will probably have to install OS-vendor supplied libraries to satisfy some gem install requirements.
3. Create the database and run rake , modifying "config/database.yml" to suit your environment.
4. Modify "config/initializers/00_inscriptio_init.rb"
5. Run bootstrap rake tasks:

```Shell
 rake inscriptio:bootstrap:run_all
 rake inscriptio:cron_task:setup_crontab
```

This populates the instance with some necessary basic items, and creates a cron task to periodically do things like expire notifications, send notices, et cetera: 

```Shell
 rake inscriptio:cron_task:run_all
```

## Order of Operations for Fresh Install

1. Sign in as admin
2. Create User Types (may change once PIN is in)
3. Create School Affiliations (may change once PIN is in)
4. Create library
5. Create floors
6. Create asset types
7. Upload/create assets (for upload you will need floor and asset types ID's)
8. Add assets to floor map (remember to hit 'Apply' button to save asset on map)
9. Go to 'Reservation Notices' section and click 'Generate Notices'

## Suggested Step for Developers

A git pre-commit hook is provided whose purpose is to keep those pesky 'console.log' and 'binding.pry' statements  out of the repository.

To install:

```Shell
  ln -s /path/to/Inscriptio/pre-commit.sh .git/hooks/pre-commit
```

You can suppress the pre-commit hook by doing:

```Shell
  git commit --no-verify
```

... but don't.

## Contributors

* Daniel Collis-Puro: http://github.com/djcp
* Anita Patel: http://github.com/apatel
* Justin Clark: http://github.com/jdcc
* Dave Mayo: http://github.com/pobocks

## License and Copyright

This application is released under a GPLv3 license.

2011 President and Fellows of Harvard College
