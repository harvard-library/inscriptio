# Development Notes
## Unusual gems and extensions
Inscriptio is, by and large, a pretty normal Rails app, and a general familiarity with Ruby and Rails should be enough to get you going.  There are a few quirks that developers should be aware of before starting; most of which concern extensions to ActiveRecord.

### [Paranoia](https://github.com/radar/paranoia)
Inscriptio makes fairly extensive use of [Paranoia](https://github.com/radar/paranoia), a gem that provides "soft-delete" of ActiveRecord records.  Any model with `acts_as_paranoid` in its `model.rb` file and a `deleted_at` column in its table has this active.

It's important to understand the ramifications this has for associations with `:dependent => :destroy` relationships.  Any "parent" model that has a `:dependent => :destroy` with a paranoid "child" model MUST also be paranoid, otherwise referential integrity constraints will prevent deletion of the parent.
  
One thing to especially watch out for - [Paranoia](https://github.com/radar/paranoia) uses a default scope to hide soft-deleted records.  I suggest at minimum reading through the readme for [Paranoia](https://github.com/radar/paranoia) before doing any work in models or at the Rails console.

### pluck_all
In versions of Rails < 4, the `pluck` method can only be used on a single column.  Inscriptio uses an initializer located at `ROOT/config/pluck_all.rb` to add a `pluck_all` method to the `ActiveRecord::Relation` and `ActiveRecord::Base` classes, to allow convenient memory-efficient operations on multiple columns.

The basic code is taken from [here](http://meltingice.net/2013/06/11/pluck-multiple-columns-rails/), and wrapped in an `ActiveSupport::Concern`

Documentation for Rails 3.2 API objects and methods can be found here: http://rails.documentation.codyrobbins.com/3.2.13/

## Git Integration

A git pre-commit hook is provided whose purpose is to keep those pesky 'console.log' and 'binding.pry' statements  out of the repository.

To install:

```Shell
  ln -s /path/to/Inscriptio/pre-commit.sh .git/hooks/pre-commit
```

You can suppress the pre-commit hook by doing:

```Shell
  git commit --no-verify
```

... but in general, don't.
