defmodule LzhWeb.Admin.UserResetPasswordLive do
  use LzhWeb, :admin_live_view

  alias Lzh.Admin

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.h1>Вход</.h1>

      <.header class="text-center">Смяна на паролата</.header>

      <.simple_form
        for={@form}
        id="reset_password_form"
        phx-submit="reset_password"
        phx-change="validate"
      >
        <.error :if={@form.errors != []}>
          Опа, нещо се обърка! Виж грешките по-долу.
        </.error>

        <.input field={@form[:password]} type="password" label="Нова парола" required />
        <.input
          field={@form[:password_confirmation]}
          type="password"
          label="Още веднъж новата парола"
          required
        />
        <:actions>
          <.button phx-disable-with="Сменяне..." class="w-full">Смени паролата</.button>
        </:actions>
      </.simple_form>

      <p class="text-center text-sm mt-4">
        <.link href={~p"/админ/вход"}>Вход</.link>
      </p>
    </div>
    """
  end

  def mount(params, _session, socket) do
    socket = assign_user_and_token(socket, params)

    form_source =
      case socket.assigns do
        %{user: user} ->
          Admin.change_user_password(user)

        _ ->
          %{}
      end

    {:ok, assign_form(socket, form_source), temporary_assigns: [form: nil]}
  end

  # Do not log in the user after reset password to avoid a
  # leaked token giving the user access to the account.
  def handle_event("reset_password", %{"user" => user_params}, socket) do
    case Admin.reset_user_password(socket.assigns.user, user_params) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Паролата ти е сменена.")
         |> redirect(to: ~p"/админ/вход")}

      {:error, changeset} ->
        {:noreply, assign_form(socket, Map.put(changeset, :action, :insert))}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Admin.change_user_password(socket.assigns.user, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_user_and_token(socket, %{"token" => token}) do
    if user = Admin.get_user_by_reset_password_token(token) do
      assign(socket, user: user, token: token)
    else
      socket
      |> put_flash(:error, "Връзката към страницата за смяна на паролата не важи.")
      |> redirect(to: ~p"/админ/вход")
    end
  end

  defp assign_form(socket, %{} = source) do
    assign(socket, :form, to_form(source, as: "user"))
  end
end
