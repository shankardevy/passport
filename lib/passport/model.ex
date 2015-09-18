defmodule Passport.Model do
  import Ecto.Query
  import String, only: [downcase: 1]

  def repo do
    Application.get_env(:passport, :repo)
  end

  def user_model do
    Application.get_env(:passport, :user_class)
  end

  def find_user_by_email(email) do
    email = String.downcase(email)
    user_model |> repo.get_by(email: email)
  end

  def find_user_by_id(id) do
    user_model |> repo.get id
  end

end
