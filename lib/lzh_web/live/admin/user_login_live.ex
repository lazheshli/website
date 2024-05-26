defmodule LzhWeb.Admin.UserLoginLive do
  use LzhWeb, :admin_live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Вход
      </.header>

      <.simple_form for={@form} id="login_form" action={~p"/админ/вход"} phx-update="ignore">
        <.input field={@form[:email]} type="email" label="Поща" required />
        <.input field={@form[:password]} type="password" label="Парола" required />

        <:actions>
          <.input field={@form[:remember_me]} type="checkbox" label="Запомни ме" />
          <.link href={~p"/админ/забравена-парола"} class="text-sm font-semibold">
            Забравена парола
          </.link>
        </:actions>
        <:actions>
          <.button phx-disable-with="Влизане..." class="w-full">
            Влез <span aria-hidden="true">→</span>
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
