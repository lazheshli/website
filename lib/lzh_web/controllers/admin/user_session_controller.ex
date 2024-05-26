defmodule LzhWeb.Admin.UserSessionController do
  use LzhWeb, :controller

  alias Lzh.Admin
  alias LzhWeb.Admin.UserAuth

  def create(conn, %{"_action" => "password_updated"} = params) do
    conn
    |> put_session(:user_return_to, ~p"/админ/настройки")
    |> create(params, "Паролата е сменена.")
  end

  def create(conn, params) do
    create(conn, params, "Хайде на работа!")
  end

  defp create(conn, %{"user" => user_params}, info) do
    %{"email" => email, "password" => password} = user_params

    if user = Admin.get_user_by_email_and_password(email, password) do
      conn
      |> put_flash(:info, info)
      |> UserAuth.log_in_user(user, user_params)
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      conn
      |> put_flash(:error, "Грешна поща и/или парола.")
      |> put_flash(:email, String.slice(email, 0, 160))
      |> redirect(to: ~p"/админ/вход")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Излезе ти.")
    |> UserAuth.log_out_user()
  end
end
