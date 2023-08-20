defmodule LzhWeb.ElectionLive.Show do
  use LzhWeb, :live_view

  alias Lzh.{Elections, Politicians, Statements}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    election = Elections.get_election!(id)
    statements = Statements.list_statements()

    politicians =
      statements
      |> Enum.map(fn statement -> statement.politician end)
      |> Enum.into(MapSet.new())
      |> Enum.sort_by(& &1.name)

    parties =
      politicians
      |> Enum.map(fn politician -> politician.party end)
      |> Enum.into(MapSet.new())
      |> Enum.sort_by(& &1.name)

    socket =
      socket
      |> assign(:page_title, "Избори")
      |> assign(:election, election)
      |> assign(:parties, parties)
      |> assign(:selected_party_id, nil)
      |> assign(:politicians, politicians)
      |> assign(:selected_politician_id, nil)
      |> assign(:statements, statements)

    {:noreply, socket}
  end

  @impl true
  def handle_event("toggle_politician", %{"id" => politician_id}, socket) do
    politician = Politicians.get_politician!(politician_id)

    socket =
      if socket.assigns.selected_politician_id == politician.id do
        statements = Statements.list_statements()

        socket
        |> assign(:selected_politician_id, nil)
        |> assign(:statements, statements)
      else
        statements =
          Statements.list_statements()
          |> Enum.filter(fn statement -> statement.politician_id == politician.id end)

        socket
        |> assign(:selected_politician_id, politician.id)
        |> assign(:statements, statements)
      end

    {:noreply, socket}
  end
end
