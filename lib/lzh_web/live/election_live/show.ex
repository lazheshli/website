defmodule LzhWeb.ElectionLive.Show do
  use LzhWeb, :live_view

  alias Lzh.{Elections, Statements}

  #
  # life cycle
  #

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
      |> assign(:selected_all, true)
      |> assign(:selected_party_id, nil)
      |> assign(:selected_politician_id, nil)
      |> assign(:selected_statements, statements)

    {:ok, socket}
  end

  #
  # event handlers
  #

  @impl true
  def handle_event("toggle_party", %{"party" => toggled_party_id}, socket) do
    %{selected_party_id: selected_party_id, statements: statements} = socket.assigns

    toggled_party_id = String.to_integer(toggled_party_id)

    socket =
      if toggled_party_id == selected_party_id do
        socket
        |> assign(:selected_all, true)
        |> assign(:selected_party_id, nil)
        |> assign(:selected_politician_id, nil)
        |> assign(:selected_statements, statements)
      else
        selected_statements =
          Enum.filter(statements, fn statement ->
            statement.politician.party.id == toggled_party_id
          end)

        socket
        |> assign(:selected_all, false)
        |> assign(:selected_party_id, toggled_party_id)
        |> assign(:selected_politician_id, nil)
        |> assign(:selected_statements, selected_statements)
      end

    {:noreply, socket}
  end

  @impl true
  def handle_event("toggle_politician", %{"politician" => toggled_politician_id}, socket) do
    %{selected_politician_id: selected_politician_id, statements: statements} = socket.assigns

    toggled_politician_id = String.to_integer(toggled_politician_id)

    socket =
      if toggled_politician_id == selected_politician_id do
        socket
        |> assign(:selected_all, true)
        |> assign(:selected_party_id, nil)
        |> assign(:selected_politician_id, nil)
        |> assign(:selected_statements, statements)
      else
        selected_statements =
          Enum.filter(statements, fn statement ->
            statement.politician.id == toggled_politician_id
          end)

        socket
        |> assign(:selected_all, false)
        |> assign(:selected_party_id, nil)
        |> assign(:selected_politician_id, toggled_politician_id)
        |> assign(:selected_statements, selected_statements)
      end

    {:noreply, socket}
  end

  @impl true
  def handle_event("select_party", %{"party" => party_id}, socket) do
    %{statements: statements} = socket.assigns

    party_id = String.to_integer(party_id)

    socket =
      if party_id == 0 do
        socket
        |> assign(:selected_all, true)
        |> assign(:selected_party_id, nil)
        |> assign(:selected_politician_id, nil)
        |> assign(:selected_statements, statements)
      else
        selected_statements =
          Enum.filter(statements, fn statement ->
            statement.politician.party.id == party_id
          end)

        socket
        |> assign(:selected_all, false)
        |> assign(:selected_party_id, party_id)
        |> assign(:selected_politician_id, nil)
        |> assign(:selected_statements, selected_statements)
      end

    {:noreply, socket}
  end

  @impl true
  def handle_event("select_politician", %{"politician" => politician_id}, socket) do
    %{politicians: politicians, statements: statements} = socket.assigns

    politician_id = String.to_integer(politician_id)

    socket =
      if politician_id == 0 do
        socket
        |> assign(:selected_all, true)
        |> assign(:selected_politician_id, nil)
        |> assign(:selected_statements, statements)
      else
        selected_statements =
          Enum.filter(statements, fn statement ->
            statement.politician.id == politician_id
          end)

        party_id =
          politicians
          |> Enum.find(&(&1.id == politician_id))
          |> Map.get(:party_id)

        socket
        |> assign(:selected_all, false)
        |> assign(:selected_party_id, party_id)
        |> assign(:selected_politician_id, politician_id)
        |> assign(:selected_statements, selected_statements)
      end

    {:noreply, socket}
  end

  @impl true
  def handle_event("select_all", _params, socket) do
    %{statements: statements} = socket.assigns

    socket =
      socket
      |> assign(:selected_all, true)
      |> assign(:selected_party_id, nil)
      |> assign(:selected_politician_id, nil)
      |> assign(:selected_statements, statements)

    {:noreply, socket}
  end

  @impl true
  def handle_event(_event, _params, socket) do
    {:noreply, socket}
  end

  #
  # view functions
  #

  def filter_by_party(politicians, party_id) when is_integer(party_id) do
    Enum.filter(politicians, &(&1.party_id == party_id))
  end

  def filter_by_party(politicians, nil) do
    politicians
  end
end
