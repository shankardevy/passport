# Passport
Passport is a ready to use authentication library for Phoenix. Using Passport is as easy as just running this simple command `$ mix passport.install`

Passport is designed to have minimal code hidden behind the library and expose all the controllers, templates and views in your project with some default values.

Passport is WIP. Bug reports and wish list from users are most welcome!

## Installation

  1. Add passport to your list of dependencies in `mix.exs`:

        def deps do
          [{:passport, "~> 0.0.4"}]
        end

  2. `$ mix do deps.get, compile`

  3. `$ mix passport.install`

## Example

  1. `$ git clone git@github.com:opendrops/passport.git`

  2. `$ cd passport/example_app`

  3. `$ mix do deps.get, compile`

  4. `$ mix phoenix.server`

  Go to `http://localhost:4000` for a demo.

  
