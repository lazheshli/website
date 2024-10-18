defmodule LzhWeb.Admin.ElectionsLive.AvatarForm do
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
  def update(%{action: action, avatar: avatar, election: election}, socket) do
    changeset = Politicians.change_avatar(avatar)

    socket =
      socket
      |> assign(:election, election)
      |> assign(:avatar, avatar)
      |> assign(:action, action)
      |> assign(:politicians_for_select, list_politicians_for_select())
      |> assign_form(changeset)

    {:ok, socket}
  end

  #
  # event handlers
  #

  @impl true
  def handle_event("validate", %{"avatar" => params}, socket) do
    changeset =
      socket.assigns.avatar
      |> Politicians.change_avatar(params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  @impl true
  def handle_event("save", %{"avatar" => avatar_params}, socket) do
    save(socket, socket.assigns.action, avatar_params)
  end

  #
  # helpers
  #

  defp list_politicians_for_select do
    Politicians.list_politicians()
    |> Enum.into(Keyword.new(), &{&1.name, &1.id})
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp save(socket, :new, params) do
    election = socket.assigns.election

    params =
      params
      |> Map.put("election_id", election.id)

    socket =
      case Politicians.create_avatar(params) do
        {:ok, avatar} ->
          notify_parent({:saved, avatar})

          socket
          |> put_flash(:info, "Добавен е нов играч.")
          |> push_patch(to: ~p"/админ/избори/#{election.id}/играчи")

        {:error, changeset} ->
          assign_form(socket, changeset)
      end

    {:noreply, socket}
  end

  defp save(socket, :edit, params) do
    election = socket.assigns.election

    socket =
      case Politicians.update_avatar(socket.assigns.avatar, params) do
        {:ok, avatar} ->
          notify_parent({:saved, avatar})

          socket
          |> put_flash(:info, "Играчът е обновен.")
          |> push_patch(to: ~p"/админ/избори/#{election.id}/играчи")

        {:error, changeset} ->
          assign_form(socket, changeset)
      end

    {:noreply, socket}
  end

  defp notify_parent(message) do
    send(self(), message)
  end
end
