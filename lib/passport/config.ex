defmodule Passport.Config do
  @default_config [
    repo: "nil",
    account_module: "nil",
    account_user: "nil",
    auth_keys: ["email"],
    enabled_auths: [],
    auth_module: nil,
    auth_password: nil,
  ]

  def default_config do
    @default_config
  end

  @default_config
  |> Keyword.keys()
  |> Enum.each(fn key ->
       def unquote(key)() do
         Application.get_env(:passport, unquote(key))
       end
     end)

end
