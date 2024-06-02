defmodule LzhWeb.Admin.UserForgotPasswordLiveTest do
  use LzhWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Lzh.AdminFixtures

  alias Lzh.Admin
  alias Lzh.Repo

  describe "Forgot password page" do
    test "renders email page", %{conn: conn} do
      {:ok, lv, html} = live(conn, ~p"/админ/забравена-парола")

      assert html =~ "Забравил си си паролата?"
      assert has_element?(lv, ~s|a[href="#{~p"/админ/вход"}"]|, "Обратно")
    end

    test "redirects if already logged in", %{conn: conn} do
      result =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/админ/забравена-парола")
        |> follow_redirect(conn, ~p"/админ")

      assert {:ok, _conn} = result
    end
  end

  describe "Reset link" do
    setup do
      %{user: user_fixture()}
    end

    test "sends a new reset password token", %{conn: conn, user: user} do
      {:ok, lv, _html} = live(conn, ~p"/админ/забравена-парола")

      {:ok, conn} =
        lv
        |> form("#reset_password_form", user: %{"email" => user.email})
        |> render_submit()
        |> follow_redirect(conn, ~p"/админ/вход")

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Ако пощата ти е в базата ни данни"

      assert Repo.get_by!(Admin.UserToken, user_id: user.id).context ==
               "reset_password"
    end

    test "does not send reset password token if email is invalid", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/админ/забравена-парола")

      {:ok, conn} =
        lv
        |> form("#reset_password_form", user: %{"email" => "unknown@example.com"})
        |> render_submit()
        |> follow_redirect(conn, ~p"/админ/вход")

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Ако пощата ти е в базата ни данни"
      assert Repo.all(Admin.UserToken) == []
    end
  end
end
