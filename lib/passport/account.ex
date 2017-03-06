defmodule Passport.Account do
  @callback get_user(String.t) :: map

  # defmacro __using__(opts) do
  #   quote do
  #     @behaviour Passport.Account
  #
  #   end
  # end
end
