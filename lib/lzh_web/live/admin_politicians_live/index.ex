defmodule LzhWeb.Admin.PoliticiansLive.Index do
  use LzhWeb, :admin_live_view

  alias Lzh.{Elections, Politicians}

  @impl true
  def mount(%{} = _params, %{} = _assigns, socket) do
    socket =
      socket
      |> assign_politicians()
      |> assign(:page_title, "Политици")

    {:ok, socket}
  end

  #
  # event handlers
  #

  @impl true
  def handle_event("delete", %{"id" => politician_id}, socket) do
    {:ok, politician} =
      politician_id
      |> Politicians.get_politician!()
      |> Politicians.delete_politician()

    socket =
      socket
      |> assign_politicians()
      |> put_flash(:info, "#{politician.name} вече не цапа базата ни данни.")

    {:noreply, socket}
  end

  #
  # view functions
  #

  def election_name(%{} = election) do
    name = Elections.election_name(election)
    month_name = Elections.election_month_name(election)

    "#{String.downcase(name)} #{month_name} #{election.date.year}"
  end

  #
  # helpers
  #

  defp assign_politicians(socket) do
    politicians =
      Politicians.list_politicians()
      |> Enum.map(fn politician ->
        Map.put(politician, :avatars, Politicians.list_avatars(politician))
      end)

    assign(socket, :politicians, politicians)
  end
end
