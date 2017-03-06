defmodule Passport.Password.Crypto do
  import Comeonin.Bcrypt, only: [checkpw: 2, hashpwsalt: 1]

  def hash(password) do
    hashpwsalt(password)
  end

  def valid_password?(given_password, password_hash) do
    checkpw(given_password, password_hash)
  end
end
