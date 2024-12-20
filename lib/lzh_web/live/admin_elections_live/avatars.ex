defmodule LzhWeb.Admin.ElectionsLive.Avatars do
  use LzhWeb, :admin_live_view

  alias Lzh.{Elections, Politicians, Statements}
  alias Lzh.Politicians.Avatar

  @impl true
  def mount(%{"election" => election_id}, %{} = _assigns, socket) do
    election = Elections.get_election!(election_id)

    socket =
      socket
      |> assign(:election, election)
      |> assign_avatars()

    {:ok, socket}
  end

  @impl true
  def handle_params(%{} = params, _url, socket) do
    socket = apply_live_action(socket, socket.assigns.live_action, params)

    {:noreply, socket}
  end

  @impl true
  def handle_info({:saved, _avatar}, socket) do
    {:noreply, assign_avatars(socket)}
  end

  #
  # event handlers
  #

  @impl true
  def handle_event("delete", %{"id" => avatar_id}, socket) do
    {:ok, avatar} =
      avatar_id
      |> Politicians.get_avatar!()
      |> Politicians.delete_avatar()

    socket =
      socket
      |> assign_avatars()
      |> put_flash(:info, "#{avatar.politician.name} вече не е сред играчите за тези избори.")

    {:noreply, socket}
  end

  #
  # view functions
  #

  def or_minus(string) do
    if string != "" do
      string
    else
      "-"
    end
  end

  #
  # helpers
  #

  defp assign_avatars(socket) do
    avatars =
      socket.assigns.election
      |> Politicians.list_avatars()
      |> Enum.map(fn avatar ->
        Map.put(avatar, :num_statements, Statements.count_statements(avatar))
      end)

    assign(socket, :avatars, avatars)
  end

  defp apply_live_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Играчи")
    |> assign(:avatar_for_form, nil)
  end

  defp apply_live_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Нов играч")
    |> assign(:avatar_for_form, %Avatar{})
  end

  defp apply_live_action(socket, :edit, %{"avatar" => avatar_id}) do
    socket
    |> assign(:page_title, "Редакция на играч")
    |> assign(:avatar_for_form, Politicians.get_avatar!(avatar_id))
  end
end
