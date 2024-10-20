defmodule LzhWeb.Admin.ElectionsLive.Index do
  use LzhWeb, :admin_live_view

  alias Lzh.Elections

  @impl true
  def mount(%{} = _params, %{} = _assigns, socket) do
    socket =
      socket
      |> assign_elections()
      |> assign(:page_title, "Избори")

    {:ok, socket}
  end

  #
  # event handlers
  #

  @impl true
  def handle_event("show_statements", %{"election" => election_id}, socket) do
    election = Elections.get_election!(election_id)

    socket =
      case Elections.update_election(election, %{show_statements: true}) do
        {:ok, election} ->
          socket
          |> assign_elections()
          |> put_flash(:info, "Твърденията за изборите на #{election.date} са публикувани.")

        {:error, _changeset} ->
          put_flash(socket, :error, "Опитай пак, че нещо не стана.")
      end

    {:noreply, socket}
  end

  @impl true
  def handle_event("hide_statements", %{"election" => election_id}, socket) do
    election = Elections.get_election!(election_id)

    socket =
      case Elections.update_election(election, %{show_statements: false}) do
        {:ok, election} ->
          socket
          |> assign_elections()
          |> put_flash(:info, "Твърденията за изборите на #{election.date} са скрити.")

        {:error, _changeset} ->
          put_flash(socket, :error, "Опитай пак, че нещо не стана.")
      end

    {:noreply, socket}
  end

  #
  # helpers
  #

  defp assign_elections(socket) do
    assign(socket, :elections, Elections.list_elections())
  end
end
