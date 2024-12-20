defmodule LzhWeb.Admin.UserSettingsLive do
  use LzhWeb, :admin_live_view

  alias Lzh.Admin

  def render(assigns) do
    ~H"""
    <.h2>Настройки</.h2>

    <div class="w-full flex flex-row items-center">
      <em>Промени пощата и/или паролата, с които влизаш в този админ панел.</em>
    </div>

    <div class="space-y-12 divide-y">
      <div>
        <.simple_form
          for={@email_form}
          id="email_form"
          phx-submit="update_email"
          phx-change="validate_email"
        >
          <.h3>Поща</.h3>

          <.input field={@email_form[:email]} type="email" label="Поща" required />
          <.input
            field={@email_form[:current_password]}
            name="current_password"
            id="current_password_for_email"
            type="password"
            label="Парола"
            value={@email_form_current_password}
            required
          />
          <:actions>
            <.button phx-disable-with="Сменяне...">Смени пощата</.button>
          </:actions>
        </.simple_form>
      </div>

      <div>
        <.simple_form
          for={@password_form}
          id="password_form"
          action={~p"/админ/вход?_action=password_updated"}
          method="post"
          phx-change="validate_password"
          phx-submit="update_password"
          phx-trigger-action={@trigger_submit}
        >
          <.h3>Парола</.h3>

          <input
            name={@password_form[:email].name}
            type="hidden"
            id="hidden_user_email"
            value={@current_email}
          />
          <.input
            field={@password_form[:password]}
            type="password"
            label="Нова парола"
            required
          />
          <.input
            field={@password_form[:password_confirmation]}
            type="password"
            label="Още веднъж новата парола"
          />
          <.input
            field={@password_form[:current_password]}
            name="current_password"
            type="password"
            label="Сегашната парола"
            id="current_password_for_password"
            value={@current_password}
            required
          />
          <:actions>
            <.button phx-disable-with="Сменяне...">Смени паролата</.button>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end

  def mount(%{"token" => token}, _session, socket) do
    socket =
      case Admin.update_user_email(socket.assigns.current_user, token) do
        :ok ->
          put_flash(socket, :info, "Пощата е сменена.")

        :error ->
          put_flash(socket, :error, "Връзката към страницата за смяна на пощата не важи.")
      end

    {:ok, push_navigate(socket, to: ~p"/админ/настройки")}
  end

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    email_changeset = Admin.change_user_email(user)
    password_changeset = Admin.change_user_password(user)

    socket =
      socket
      |> assign(:current_password, nil)
      |> assign(:email_form_current_password, nil)
      |> assign(:current_email, user.email)
      |> assign(:email_form, to_form(email_changeset))
      |> assign(:password_form, to_form(password_changeset))
      |> assign(:trigger_submit, false)
      |> assign(:page_title, "Настройки")

    {:ok, socket}
  end

  def handle_event("validate_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    email_form =
      socket.assigns.current_user
      |> Admin.change_user_email(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, email_form: email_form, email_form_current_password: password)}
  end

  def handle_event("update_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Admin.apply_user_email(user, password, user_params) do
      {:ok, applied_user} ->
        Admin.deliver_user_update_email_instructions(
          applied_user,
          user.email,
          &url(~p"/админ/настройки/потвърждаване/#{&1}")
        )

        info = "Изпратихме ти връзка към страница за потвърждаване на новата поща."
        {:noreply, socket |> put_flash(:info, info) |> assign(email_form_current_password: nil)}

      {:error, changeset} ->
        {:noreply, assign(socket, :email_form, to_form(Map.put(changeset, :action, :insert)))}
    end
  end

  def handle_event("validate_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    password_form =
      socket.assigns.current_user
      |> Admin.change_user_password(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, password_form: password_form, current_password: password)}
  end

  def handle_event("update_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Admin.update_user_password(user, password, user_params) do
      {:ok, user} ->
        password_form =
          user
          |> Admin.change_user_password(user_params)
          |> to_form()

        {:noreply, assign(socket, trigger_submit: true, password_form: password_form)}

      {:error, changeset} ->
        {:noreply, assign(socket, password_form: to_form(changeset))}
    end
  end
end
