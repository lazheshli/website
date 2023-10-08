defmodule LzhWeb.ElectionLive.Show do
  use LzhWeb, :live_view

  alias Lzh.{Elections, Statements}

  @impl true
  def mount(:not_mounted_at_router, %{"election" => election_id}, socket) do
    election = Elections.get_election!(election_id)

    statements = Statements.list_statements(election)

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
      |> assign(:election, election)
      |> assign(:politicians, politicians)
      |> assign(:parties, parties)
      |> assign(:statements, statements)
      |> assign(:selected_party_id, nil)
      |> assign(:selected_politician_id, nil)
      |> assign(:selected_statements, statements)

    {:ok, socket}
  end

  @impl true
  def handle_event("select_party", %{"party" => selected_party_id}, socket) do
    %{statements: statements} = socket.assigns

    selected_party_id = String.to_integer(selected_party_id)

    selected_statements =
      Enum.filter(statements, fn statement ->
        statement.politician.party.id == selected_party_id
      end)

    socket =
      socket
      |> assign(:selected_party_id, selected_party_id)
      |> assign(:selected_politician_id, nil)
      |> assign(:selected_statements, selected_statements)

    {:noreply, socket}
  end

  @impl true
  def handle_event("select_politician", %{"politician" => selected_politician_id}, socket) do
    %{statements: statements} = socket.assigns

    selected_politician_id = String.to_integer(selected_politician_id)

    selected_statements =
      Enum.filter(statements, fn statement ->
        statement.politician.id == selected_politician_id
      end)

    socket =
      socket
      |> assign(:selected_party_id, nil)
      |> assign(:selected_politician_id, selected_politician_id)
      |> assign(:selected_statements, selected_statements)

    {:noreply, socket}
  end

  @impl true
  def handle_event(_event, _params, socket) do
    {:noreply, socket}
  end
end
