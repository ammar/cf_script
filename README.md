# CfScript [![Gem Version](https://img.shields.io/gem/v/cf_script.svg)](https://rubygems.org/gems/cf_script) [![Build Status](https://secure.travis-ci.org/ammar/cf_script.png?branch=master)](http://travis-ci.org/ammar/cf_script)

CfScript is a DSL for scripting and automating the Cloud Foundry CLI.

```ruby
# example.rb
require 'cf_script'

cf space: :development do
  workers = apps ending_with: 'worker'

  workers.each do |worker|
    app worker do
      show :state, :memory, :instances

      stop if started?

      progress 'Setting ENV variable...'
      set_env 'SOME_NAME', 'SOME_VALUE'

      progress "Restaging #{name} in #{current_space}..."
      restage
    end
  end
end
```

To see the cf commands that get executed, run with TRACE=1.
```
TRACE=1 ruby example.rb
```

---
## Requirements

* `ruby` >= 2.0
* `cf` >= 16.0

---
## Install

Install the gem with:

```gem install cf_script --pre```

Or, add it to your project's `Gemfile`:

```gem 'cf_script', '0.0.1.beta.1'```

---
## Execution Scopes

There are three execution scopes/blocks; `cf`, `space`, and `app`:

### The `cf` Block Scope
The `cf` scope is the top-level scope, it includes evertything between the
`do/end` following a call to `cf`. The scope saves the current target on
entry and restores it on exit.

```ruby
# cf target => staging

cf space: :development do
	# cf target => development
end

# cf target => staging
```

The `cf` block accepts the following options:

- `api`: Sets the API endpoint _(optional)_
- `org`: Sets the target organization _(optional)_
- `username`/`password`: Credentials to use for logging in. _(optional)_
- `space`: Sets the target space _(optional)_

_**Note**: To save the current target the `cf` block will execute `cf target`
on entry, and if it changed within the block, it wil execute `cf target SPACE`
on exit to restore it._


### The `space` Block Scope
The `space` scope is a sub-scope and can only appear within a `cf` block. It
also saves the current target on entry and restores, if changed, it on exit.

```ruby
# before cf block, target => staging

cf space: :development do
  # inside cf block, target => development

  space :production do
    # inside space block, target => production
  end

  # still inside cf block, target => development
end

# after cf block, target => staging
```

### The `app` Block Scope
The `app` scope can appear within a `cf` or `space` blocks. Within the block
the selected app is the target of commands, this means that commands that take
an application name as their first argument can be called without it.

```ruby
cf do
  app :api do
    env.each do |name, value|
      unset_env name, value
    end

    started? ? restart : start
  end
end
```

---
## Supported Commands

| Commands                              | CLI command                                             | &#x22ef; |
| ------------------------------------- | ------------------------------------------------------- |:--------:|
| **General**                           |                                                         | &#x22f1; |
| &emsp;&nbsp;_**api**_                 | `cf api URL`                                            | &#x2713; |
| &emsp;&nbsp;_**auth**_                | `cf auth USER PASSWORD`                                 | &#x2713; |
| &emsp;&nbsp;_**login**_               | `cf login -u USER -p PASSWORD [OPTIONS]`                | &#x2713; |
| &emsp;&nbsp;_**logout**_              | `cf logout`                                             | &#x2713; |
| &emsp;&nbsp;_**target**_              | `cf target [-s SPACE -o ORG]`                           | &#x2713; |
| **Applications**                      |                                                         | &#x22f1; |
| &emsp;&nbsp;_**apps**_                | `cf apps`                                               | &#x2713; |
| &emsp;&nbsp;_**app**_                 | `cf app APP_NAME`                                       | &#x2713; |
| &emsp;&nbsp;_**start**_               | `cf start APP_NAME`                                     | &#x2713; |
| &emsp;&nbsp;_**stop**_                | `cf stop APP_NAME`                                      | &#x2713; |
| &emsp;&nbsp;_**restart**_             | `cf restart APP_NAME`                                   | &#x2713; |
| &emsp;&nbsp;_**push**_                | `cf push APP_NAME [OPTIONS]`                            | &#x2713; |
| &emsp;&nbsp;_**restage**_             | `cf restage APP_NAME`                                   | &#x2713; |
| &emsp;&nbsp;_**env**_                 | `cf env APP_NAME`                                       | &#x2713; |
| &emsp;&nbsp;_**set-env**_             | `cf set-env APP_NAME VAR_NAME VAR_VALUE`                | &#x2713; |
| &emsp;&nbsp;_**unset-env**_           | `cf unset-env APP_NAME VAR_NAME`                        | &#x2713; |
| **Routes**                            |                                                         | &#x22f1; |
| &emsp;&nbsp;_**routes**_              | `cf routes`                                             | &#x2713; |
| &emsp;&nbsp;_**check-route**_         | `cf check-route HOST DOMAIN`                            | &#x2713; |
| &emsp;&nbsp;_**create-route**_        | `cf create-route SPACE DOMAIN [-n HOSTNAME]`            | &#x2713; |
| &emsp;&nbsp;_**map-route**_           | `cf map-route APP_NAME DOMAIN [-n HOSTNAME]`            | &#x2713; |
| &emsp;&nbsp;_**unmap-route**_         | `cf unmap-route APP_NAME DOMAIN [-n HOSTNAME]`          | &#x2713; |
| &emsp;&nbsp;_**delete-route**_        | `cf delete-route DOMAIN [-n HOSTNAME] [-f]`             | &#x2713; |
| **Spaces**                            |                                                         | &#x22f1; |
| &emsp;&nbsp;_**spaces**_              | `cf spaces`                                             | &#x2713; |
| &emsp;&nbsp;_**space**_               | `cf space SPACE`                                        | &#x2713; |

---
## Building
The project uses the standard rubygems package tasks, so:

To build your cloned copy of the gem, run:
```
rake build
```

To install the gem from the cloned project, run:
```
rake install
```
