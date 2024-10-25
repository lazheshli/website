defmodule LzhWeb.Admin.PoliticiansLive.PoliticianForm do
  use LzhWeb, :live_component

  alias Lzh.Politicians

  #
  # life cycle
  #

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(%{action: action, politician: politician}, socket) do
    changeset = Politicians.change_politician(politician)

    socket =
      socket
      |> assign(:politician, politician)
      |> assign(:action, action)
      |> assign_form(changeset)

    {:ok, socket}
  end

  #
  # event handlers
  #

  @impl true
  def handle_event("validate", %{"politician" => params}, socket) do
    changeset =
      socket.assigns.politician
      |> Politicians.change_politician(params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  @impl true
  def handle_event("save", %{"politician" => params}, socket) do
    save(socket, socket.assigns.action, params)
  end

  #
  # helpers
  #

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp save(socket, :new, params) do
    socket =
      case Politicians.create_politician(params) do
        {:ok, politician} ->
          notify_parent({:saved, politician})

          socket
          |> put_flash(:info, "Добавен е нов политик.")
          |> push_patch(to: ~p"/админ/политици", replace: true)

        {:error, changeset} ->
          assign_form(socket, changeset)
      end

    {:noreply, socket}
  end

  defp notify_parent(message) do
    send(self(), message)
  end
end
