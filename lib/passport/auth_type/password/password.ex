defmodule Passport.Password do
  @behaviour Passport.AuthType

  alias Passport.Config
  import Passport.Password.Crypto, only: [valid_password?: 2]


  @doc """
  Checks if the given password is valid for the account.
  """
  def valid_credential?(account, password) do
    with active_password when active_password != nil <- get_active_password(account),
         true <- valid_password?(password, active_password.password_hash)
    do
       true
    else
      error ->
       false
    end
  end


  @doc """
  Save a new password credential
  """
  def save_credential(credential) do
    # %Article{}
    # |> article_changeset(attrs)
    # |> Repo.insert()
    Config.repo.insert(credential)
  end

  @doc """
  Update an existing password credential
  """
  def update_credential(credential) do
    Config.repo.insert(credential)
  end

  @doc """
  Delete a password credential
  """
  def delete_credential(credential) do
    Config.repo.insert(credential)
  end


  @doc """
  Get the active password for the given id
  """
  defp get_active_password(%{id: id}) do
    Config.auth_password
    |> Config.repo.get_by(user_id: id)
  end
  defp get_active_password(_) do
    {:error, "Account must be map with :id key"}
  end

end
