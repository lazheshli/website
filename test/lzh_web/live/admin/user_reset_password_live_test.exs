defmodule LzhWeb.Admin.UserResetPasswordLiveTest do
  use LzhWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Lzh.AdminFixtures

  alias Lzh.Admin

  setup do
    user = user_fixture()

    token =
      extract_user_token(fn url ->
        Admin.deliver_user_reset_password_instructions(user, url)
      end)

    %{token: token, user: user}
  end

  describe "Reset password page" do
    test "renders reset password with valid token", %{conn: conn, token: token} do
      {:ok, _lv, html} = live(conn, ~p"/админ/забравена-парола/#{token}")

      assert html =~ "Смяна на паролата"
    end

    test "does not render reset password with invalid token", %{conn: conn} do
      {:error, {:redirect, to}} = live(conn, ~p"/админ/забравена-парола/грешка")

      assert to == %{
               flash: %{"error" => "Връзката към страницата за смяна на паролата не важи."},
               to: ~p"/админ/вход"
             }
    end

    test "renders errors for invalid data", %{conn: conn, token: token} do
      {:ok, lv, _html} = live(conn, ~p"/админ/забравена-парола/#{token}")

      result =
        lv
        |> element("#reset_password_form")
        |> render_change(
          user: %{"password" => "secret12", "password_confirmation" => "secret123456"}
        )

      assert result =~ "should be at least 12 character"
      assert result =~ "does not match password"
    end
  end

  describe "Reset Password" do
    test "resets password once", %{conn: conn, token: token, user: user} do
      {:ok, lv, _html} = live(conn, ~p"/админ/забравена-парола/#{token}")

      {:ok, conn} =
        lv
        |> form("#reset_password_form",
          user: %{
            "password" => "new valid password",
            "password_confirmation" => "new valid password"
          }
        )
        |> render_submit()
        |> follow_redirect(conn, ~p"/админ/вход")

      refute get_session(conn, :user_token)
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Паролата ти е сменена."
      assert Admin.get_user_by_email_and_password(user.email, "new valid password")
    end

    test "does not reset password on invalid data", %{conn: conn, token: token} do
      {:ok, lv, _html} = live(conn, ~p"/админ/забравена-парола/#{token}")

      result =
        lv
        |> form("#reset_password_form",
          user: %{
            "password" => "too short",
            "password_confirmation" => "does not match"
          }
        )
        |> render_submit()

      assert result =~ "Смяна на паролата"
      assert result =~ "should be at least 12 character(s)"
      assert result =~ "does not match password"
    end
  end

  describe "Reset password navigation" do
    test "redirects to login page when the Log in button is clicked", %{conn: conn, token: token} do
      {:ok, lv, _html} = live(conn, ~p"/админ/забравена-парола/#{token}")

      {:ok, conn} =
        lv
        |> element(~s|main a:fl-contains("Вход")|)
        |> render_click()
        |> follow_redirect(conn, ~p"/админ/вход")

      assert conn.resp_body =~ "Вход"
    end
  end
end
