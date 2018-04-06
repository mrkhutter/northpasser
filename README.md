# Northpasser

Northpasser is a lightweight Ruby wrapper of the
[Northpass API](https://app.northpass.com/api/v1/).

[Northpass](https://northpass.com) is a radical project management tool
particularly well suited to software development. If you're not familiar with
them, go check them out! :heart:


## Inspiration 
This gem is heavily inspired by [Philip Castiglione](https://github.com/PhilipCastiglione)'s 
Ruby [gem](https://github.com/PhilipCastiglione/clubhouse_ruby) for the Clubhouse API

Philip's restated philosophy on these techniques:
> ...A good API wrapper is a simpler alternative to a comprehensive client 
> library and can provide a nice interface to the API using dynamic 
> Ruby metaprogramming techniques rather than mapping functionality from 
> the API to the library piece by piece.

> This enables the wrapper to be loosely coupled to the current implementation of
> the API, which makes it more resilient to change. Also, this approach takes much
> less code and maintenance effort, allowing the developer to be lazy. A
> reasonable person might fairly assume this to be the true rationale behind the
> philosophy. They'd be right.

My "strong inspiration" is almost entirely motivated by the latter part
of Philip's philosophy :)


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'northpasser'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install northpasser

## Usage

This gem is a lightweight API wrapper. That means you'll need to refer to the
[API documentation](https://app.northpass.com/api/v1/) to figure out what resources
 and actions exist.


Instantiate an object to interface with the API:

```ruby
northpass = Northpasser::Northpass.new(<YOUR NORTHPASS API TOKEN>)
```

The API can also provide responses in CSV format instead of the default JSON:

```ruby
northpass = Northpasser::Northpass.new(<YOUR NORTHPASS API TOKEN>, response_format: :csv)
```

Then, call methods on the object matching the resource(s) and action you are
interested in. For example, if you want to list all available courses, you need to
access the endpoint at https://api.northpass.com/v1/courses. The 
northpasser gem uses an explicit action:

```ruby
northpass.courses.list
# => {
#  "links": {
#    "self": "https://api.northpass.com/v1/courses"
#  },
#  "data": [
#    {
#      "type": "courses",
#      "id": "72673479-ad0c-4e81-bb2f-47174ff09396",
#      "attributes": {
#        "name": "Getting Started with Pixel (Sample Course)",
#        "enrollments_count": 0,
#        "list_image_url": "https://d3p3alwwakpeoy.cloudfront.net/api/file/YKu1Zb0fSqmrpsNL7nbu/convert?cache=true&fit=crop&h=500&w=820",
#        "course_enrollment_link": "https://shipt.schoolkeep.com/c/071e0fd038cb23f005d5ff3f9519a8266774eafe",
#        "share_course_link": "https://shipt.schoolkeep.com/outline/j16njpjy/cover",
#        "permalink": "j16njpjy",
#        "created_at": "2017-11-10T20:09:53Z",
#        "updated_at": "2017-11-10T20:09:53Z"
#      },
#      "relationships": {
#        "categories": {
#          "data": []
#        },
#        "instructor_partnerships": {
#          "data": []
#        }
#      },
#      "links": {
#        "self": "https://api.northpass.com/v1/courses/j16njpjy",
#        "teaching": "https://app.northpass.com/courses/j16njpjy",
#        "build": {
#          "href": "https://app.northpass.com/courses/j16njpjy/builder",
#          "methods": [
#            "get"
#          ]
#        }
#      }
#    }
```

If the endpoint you want requires parameters, say if you wanted to create a
learner, you provide a hash to the action call following the resource:

```ruby
northpass.learners.create(data: { type: 'people', attributes: {email: "spiderman@marvel.com"} })
# => {
#  "data": {
#    "type": "people",
#    "id": "b813a22e-7442-449b-a150-d3275a2cee29",
#    "attributes": {
#      "created_at": "2018-04-06T16:05:17Z",
#      "email": "spiderman@marvel.com",
#      "updated_at": "2018-04-06T16:05:17Z",
#      "unsubscribed": false
#    },
#    "links": {
#      "self": "https://api.northpass.com/v1/people/b813a22e-7442-449b-a150-d3275a2cee29",
#      "teaching": "https://app.northpass.com/people/b813a22e-7442-449b-a150-d3275a2cee29"
#    },
#    "relationships": {
#      "school": {
#        "data": {
#          "type": "schools",
#          "id": "3825127e-011b-4b71-a6bb-543244406292"
#        }
#      }
#    }
#  }
#}
```

If you are building a path and you make a mistake, you can clear the path:

```ruby
northpass.courses
northpass.epics
northpass.clear_path
# => []
```

You don't need to clear the path after a complete request, as that happens
automatically.


The resources and methods are enumerated in the source code
[here](https://github.com/mrkhutter/northpasser/blob/master/lib/northpasser/constants.rb)
but generally you should find the url you are interested in from the docs.

## Errors

Errors are passed through from the API relatively undecorated:

```ruby
northpass = Northpasser::Northpass.new("unrecognized token")
northpass.courses.list
# => {
#  "errors": [
#    {
#      "status": "401",
#      "title": "Unauthorized",
#      "detail": "You don't have the necessary credentials",
#      "source": {}
#    }
#  ]
#}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies and
following the instructions. Specifically, you can choose to provide a genuine
northpass API token in the `.env` file. This will be important if you want to
use `bin/console` for an interactive prompt that allows you to experiment with
the gem and real API responses.

Use `rake spec` to run the tests. The tests don't make external requests but
rather use VCR for stubbed responses. If you want to play with the tests and
get real API responses (perhaps to extend the suite or for a new feature) then
you'll need to have an API token in the env as described above.

The current test suite is far from exhaustive and could do with some
love.

**NB: If you have implemented a feature that requires a new cassette, make sure
you change the uri referenced by the cassette you added to remove the API token
if you have updated the environment to use your token. Otherwise your API token
will be in publically visible from the code in this repo.**

## Contributing

Bug reports and pull requests are entirely welcome on GitHub at
https://github.com/philipcastiglione/northpasser.


## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).
