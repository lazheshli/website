defmodule LzhWeb.Admin.UserForgotPasswordLive do
  use LzhWeb, :admin_live_view

  alias Lzh.Admin

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Забравил си си паролата?
        <:subtitle>Ще изпратим инструкции за смяна на паролата на пощата ти</:subtitle>
      </.header>

      <.simple_form for={@form} id="reset_password_form" phx-submit="send_email">
        <.input field={@form[:email]} type="email" placeholder="Поща" required />
        <:actions>
          <.button phx-disable-with="Изпращане..." class="w-full">
            Изпрати инструкции за смяна на паролата
          </.button>
        </:actions>
      </.simple_form>
      <p class="text-center text-sm mt-4">
        <.link href={~p"/админ/вход"}>Вход</.link>
      </p>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}, as: "user"))}
  end

  def handle_event("send_email", %{"user" => %{"email" => email}}, socket) do
    if user = Admin.get_user_by_email(email) do
      Admin.deliver_user_reset_password_instructions(
        user,
        &url(~p"/админ/забравена-парола/#{&1}")
      )
    end

    info =
      "Ако пощата ти е в базата ни данни, след малко ще получиш инструкции за смяна на паролата."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/админ/вход")}
  end
end
