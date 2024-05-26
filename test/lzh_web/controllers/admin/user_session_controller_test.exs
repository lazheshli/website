defmodule LzhWeb.UserSessionControllerTest do
  use LzhWeb.ConnCase, async: true

  import Lzh.AdminFixtures

  setup do
    %{user: user_fixture()}
  end

  describe "POST /админ/вход" do
    test "logs the user in", %{conn: conn, user: user} do
      conn =
        post(conn, ~p"/админ/вход", %{
          "user" => %{"email" => user.email, "password" => valid_user_password()}
        })

      assert get_session(conn, :user_token)
      assert redirected_to(conn) == ~p"/админ"

      # Now do a logged in request and assert on the menu
      conn = get(conn, ~p"/админ")
      response = html_response(conn, 200)
      assert response =~ user.email
      assert response =~ ~p"/админ/настройки"
      assert response =~ ~p"/админ/изход"
    end

    test "logs the user in with remember me", %{conn: conn, user: user} do
      conn =
        post(conn, ~p"/админ/вход", %{
          "user" => %{
            "email" => user.email,
            "password" => valid_user_password(),
            "remember_me" => "true"
          }
        })

      assert conn.resp_cookies["_lzh_web_user_remember_me"]
      assert redirected_to(conn) == ~p"/админ"
    end

    test "logs the user in with return to", %{conn: conn, user: user} do
      conn =
        conn
        |> init_test_session(user_return_to: "/foo/bar")
        |> post(~p"/админ/вход", %{
          "user" => %{
            "email" => user.email,
            "password" => valid_user_password()
          }
        })

      assert redirected_to(conn) == "/foo/bar"
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Хайде на работа!"
    end

    test "login following password update", %{conn: conn, user: user} do
      conn =
        conn
        |> post(~p"/админ/вход", %{
          "_action" => "password_updated",
          "user" => %{
            "email" => user.email,
            "password" => valid_user_password()
          }
        })

      assert redirected_to(conn) == ~p"/админ/настройки"
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Паролата е сменена."
    end

    test "redirects to login page with invalid credentials", %{conn: conn} do
      conn =
        post(conn, ~p"/админ/вход", %{
          "user" => %{"email" => "invalid@email.com", "password" => "invalid_password"}
        })

      assert Phoenix.Flash.get(conn.assigns.flash, :error) == "Грешна поща и/или парола."
      assert redirected_to(conn) == ~p"/админ/вход"
    end
  end

  describe "DELETE /админ/изход" do
    test "logs the user out", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user) |> delete(~p"/админ/изход")
      assert redirected_to(conn) == ~p"/админ/вход"
      refute get_session(conn, :user_token)
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Излезе ти."
    end

    test "succeeds even if the user is not logged in", %{conn: conn} do
      conn = delete(conn, ~p"/админ/изход")
      assert redirected_to(conn) == ~p"/админ/вход"
      refute get_session(conn, :user_token)
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Излезе ти."
    end
  end
end
