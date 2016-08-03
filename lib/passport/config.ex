defmodule Passport.Config do
  def repo do
    Application.get_env(:passport, :repo)
  end

  def resource do
    Application.get_env(:passport, :resource)
  end
end
