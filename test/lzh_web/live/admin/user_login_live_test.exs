defmodule LzhWeb.Admin.UserLoginLiveTest do
  use LzhWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Lzh.AdminFixtures

  describe "Log in page" do
    test "renders log in page", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/админ/вход")

      assert html =~ "Вход"
      assert html =~ "Забравена парола"
    end

    test "redirects if already logged in", %{conn: conn} do
      result =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/админ/вход")
        |> follow_redirect(conn, ~p"/админ")

      assert {:ok, _conn} = result
    end
  end

  describe "user login" do
    test "redirects if user login with valid credentials", %{conn: conn} do
      password = "123456789abcd"
      user = user_fixture(%{password: password})

      {:ok, lv, _html} = live(conn, ~p"/админ/вход")

      form =
        form(lv, "#login_form", user: %{email: user.email, password: password, remember_me: true})

      conn = submit_form(form, conn)

      assert redirected_to(conn) == ~p"/админ"
    end

    test "redirects to login page with a flash error if there are no valid credentials", %{
      conn: conn
    } do
      {:ok, lv, _html} = live(conn, ~p"/админ/вход")

      form =
        form(lv, "#login_form",
          user: %{email: "test@email.com", password: "123456", remember_me: true}
        )

      conn = submit_form(form, conn)

      assert Phoenix.Flash.get(conn.assigns.flash, :error) == "Грешна поща и/или парола."

      assert redirected_to(conn) == ~p"/админ/вход"
    end
  end

  describe "login navigation" do
    test "redirects to forgot password page when the Forgot Password button is clicked", %{
      conn: conn
    } do
      {:ok, lv, _html} = live(conn, ~p"/админ/вход")

      {:ok, conn} =
        lv
        |> element(~s|main a:fl-contains("Забравена парола")|)
        |> render_click()
        |> follow_redirect(conn, ~p"/админ/забравена-парола")

      assert conn.resp_body =~ "Забравил си си паролата?"
    end
  end
end
