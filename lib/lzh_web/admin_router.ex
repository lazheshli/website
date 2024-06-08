defmodule LzhWeb.Admin.Router do
  use LzhWeb, :router

  import LzhWeb.Admin.UserAuth

  alias LzhWeb.Admin.UserAuth

  scope "/", LzhWeb.Admin do
    pipe_through [:fetch_current_user, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{UserAuth, :redirect_if_user_is_authenticated}] do
      live "/админ/вход", UserLoginLive, :new
      live "/админ/забравена-парола", UserForgotPasswordLive, :new
      live "/админ/забравена-парола/:token", UserResetPasswordLive, :edit
    end

    post "/админ/вход", UserSessionController, :create
  end

  scope "/", LzhWeb.Admin do
    pipe_through [:fetch_current_user, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{UserAuth, :ensure_authenticated}] do
      live "/админ", HomeLive

      live "/админ/избори", ElectionsLive.Index, :index

      live "/админ/твърдения", StatementsLive.Index, :index
      live "/админ/твърдения/ново", StatementsLive.Index, :new
      live "/админ/твърдения/:id/редакция", StatementsLive.Index, :edit

      live "/админ/настройки", UserSettingsLive, :edit
      live "/админ/настройки/потвърждаване/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/", LzhWeb.Admin do
    pipe_through [:fetch_current_user]

    delete "/админ/изход", UserSessionController, :delete
  end
end
