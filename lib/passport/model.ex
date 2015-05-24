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
    from(u in user_model, select: u, where: u.email == ^downcase(email))
      |> repo.one
  end

  def find_user_by_id(id) do
    from(u in user_model, select: u, where: u.id == ^id)
      |> repo.one
  end

end
