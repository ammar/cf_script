# CfScript

CfScript is a DSL for scripting and automating the Cloud Foundry CLI.

```ruby
require 'cf_script'

cf space: 'staging' do
  workers = apps ending_with: 'worker'

  workers.each do |worker|
    app worker do
      set_env 'SOME_NAME', 'SOME_VALUE'

      restart if started?
    end
  end
end
```

## Requirements

* `ruby` >= 2.0
* `cf` >= 16.0

---
## Install

Install the gem with:

  `gem install cf_script --pre`

Or, add it to your project's `Gemfile`:

```gem 'cf_script', '0.1.0.pre'```

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
| &emsp;&nbsp;_**app**_                 | `cf app APP_NAME`                                       | &#x2713; |
| &emsp;&nbsp;_**apps**_                | `cf apps`                                               | &#x2713; |
| &emsp;&nbsp;_**start**_               | `cf start APP_NAME`                                     | &#x2713; |
| &emsp;&nbsp;_**stop**_                | `cf stop APP_NAME`                                      | &#x2713; |
| &emsp;&nbsp;_**restart**_             | `cf restart APP_NAME`                                   | &#x2713; |
| &emsp;&nbsp;_**push**_                | `cf push [OPTIONS]`                                     | &#x2713; |
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
| &emsp;&nbsp;_**space**_               | `cf space SPACE`                                        | &#x2713; |
| &emsp;&nbsp;_**spaces**_              | `cf spaces`                                             | &#x2713; |

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
