# Passport
## Experimental. 

Passport is an easy to use Authentication library for Phoenix 1.3.

Passport is rewritten to make use of the context design pattern of Phoenix 1.3.

Passport organises the code in your project in the directory `lib/your_app/auth`

## Installation and Usage

  1. Add passport to your list of dependencies in `mix.exs`:

        def deps do
          [{:passport, git: "https://github.com/opendrops/passport.git"}]
        end

  2. `$ mix do deps.get, compile`

  3. `$ mix passport.setup`

  4. Follow the instruction displayed on screen.


## State of development

This project is currently under development. Though it works, there are a lot of scope for improvement and not thoroughly tested. My goal is to make Passport a solid library for authentication. See the issues queues for the list of tasks to be done.


## License

Passport is Copyright © 2017 Opendrops. It is free software, and may be
redistributed under the terms specified in the MIT-LICENSE file.

## About Opendrops


![Opendrops](http://www.opendrops.com/img/logo.png)

Passport is maintained and funded by Opendrops. We love open source software! If you have a project in Elixir or Ruby, get in touch with us.
