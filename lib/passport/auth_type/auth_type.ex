defmodule Passport.AuthType do
  @callback valid_credential?(map, String.t) :: map
  @callback save_credential(map) :: atom
  @callback update_credential(integer, map) :: atom
  @callback delete_credential(integer) :: atom
end
