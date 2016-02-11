defmodule Passport.Password do
  def hash(password) do
    Comeonin.Bcrypt.hashpwsalt(password)
  end
end
