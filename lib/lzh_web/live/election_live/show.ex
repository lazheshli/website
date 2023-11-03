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

    towns =
      politicians
      |> Enum.map(fn politician -> politician.town end)
      |> Enum.into(MapSet.new())
      |> Enum.sort()

    socket =
      socket
      |> assign(:election, election)
      |> assign(:politicians, politicians)
      |> assign(:parties, parties)
      |> assign(:towns, towns)
      |> assign(:statements, statements)
      |> assign(:in_two_rounds, Enum.any?(statements, &(&1.round == 2)))
      |> assign(:selected_all, true)
      |> assign(:selected_party_id, nil)
      |> assign(:selected_town, nil)
      |> assign(:selected_politician_id, nil)
      |> assign(:selected_round, nil)
      |> assign(:selected_statements, statements)

    {:ok, socket}
  end

  #
  # event handlers
  #

  # Used for parliamentary elections — :selected_town and :selected_round are
  # not relevant.
  @impl true
  def handle_event("toggle_party", %{"party" => toggled_party_id}, socket) do
    %{selected_party_id: selected_party_id} = socket.assigns

    toggled_party_id = String.to_integer(toggled_party_id)

    socket =
      if toggled_party_id == selected_party_id do
        socket
        |> assign(:selected_all, true)
        |> assign(:selected_party_id, nil)
        |> assign(:selected_politician_id, nil)
        |> assign_selected_statements()
      else
        socket
        |> assign(:selected_all, false)
        |> assign(:selected_party_id, toggled_party_id)
        |> assign(:selected_politician_id, nil)
        |> assign_selected_statements()
      end

    {:noreply, socket}
  end

  # Used for local elections — :selected_party_id is not relevant.
  @impl true
  def handle_event("toggle_town", %{"town" => toggled_town}, socket) do
    %{selected_town: selected_town} = socket.assigns

    socket =
      if toggled_town == selected_town do
        socket
        |> assign(:selected_all, true)
        |> assign(:selected_town, nil)
        |> assign(:selected_politician_id, nil)
        |> assign_selected_statements()
      else
        socket
        |> assign(:selected_all, false)
        |> assign(:selected_town, toggled_town)
        |> assign(:selected_politician_id, nil)
        |> assign_selected_statements()
      end

    {:noreply, socket}
  end

  # Used for all types of elections.
  @impl true
  def handle_event("toggle_politician", %{"politician" => toggled_politician_id}, socket) do
    %{selected_politician_id: selected_politician_id} = socket.assigns

    toggled_politician_id = String.to_integer(toggled_politician_id)

    socket =
      if toggled_politician_id == selected_politician_id do
        socket
        |> assign(:selected_all, true)
        |> assign(:selected_party_id, nil)
        |> assign(:selected_town, nil)
        |> assign(:selected_politician_id, nil)
        |> assign_selected_statements()
      else
        socket
        |> assign(:selected_all, false)
        |> assign(:selected_party_id, nil)
        |> assign(:selected_town, nil)
        |> assign(:selected_politician_id, toggled_politician_id)
        |> assign_selected_statements()
      end

    {:noreply, socket}
  end

  # Used for local elections — :selected_party_id is not relevant.
  @impl true
  def handle_event("select_round", %{"round" => round}, socket) do
    round =
      case String.to_integer(round) do
        0 -> nil
        int -> int
      end

    socket =
      socket
      |> assign(:selected_round, round)
      |> assign(:selected_all, true)
      |> assign(:selected_town, nil)
      |> assign(:selected_politician_id, nil)
      |> assign_selected_statements()

    {:noreply, socket}
  end

  # Used for parliamentary elections — :selected_town and :selected_round are
  # not relevant.
  @impl true
  def handle_event("select_party", %{"party" => party_id}, socket) do
    party_id =
      case String.to_integer(party_id) do
        0 -> nil
        id -> id
      end

    socket =
      socket
      |> assign(:selected_all, party_id == nil)
      |> assign(:selected_party_id, party_id)
      |> assign(:selected_politician_id, nil)
      |> assign_selected_statements()

    {:noreply, socket}
  end

  # Used for local elections — :selected_party_id is not relevant.
  @impl true
  def handle_event("select_town", %{"town" => town}, socket) do
    town = if(town == "-", do: nil, else: town)

    socket =
      socket
      |> assign(:selected_all, town == nil)
      |> assign(:selected_town, town)
      |> assign(:selected_politician_id, nil)
      |> assign_selected_statements()

    {:noreply, socket}
  end

  # Used for all types of elections.
  @impl true
  def handle_event("select_politician", %{"politician" => politician_id}, socket) do
    %{
      election: election,
      politicians: politicians,
      selected_party_id: selected_party_id,
      selected_town: selected_town
    } = socket.assigns

    politician_id = String.to_integer(politician_id)

    socket =
      cond do
        politician_id == 0 and election.type == :parliamentary and selected_party_id != nil ->
          socket
          |> assign(:selected_all, false)
          |> assign(:selected_politician_id, nil)
          |> assign_selected_statements()

        politician_id == 0 and election.type == :local and selected_town != nil ->
          socket
          |> assign(:selected_all, false)
          |> assign(:selected_politician_id, nil)
          |> assign_selected_statements()

        politician_id == 0 ->
          socket
          |> assign(:selected_all, true)
          |> assign(:selected_party_id, nil)
          |> assign(:selected_town, nil)
          |> assign(:selected_politician_id, nil)
          |> assign_selected_statements()

        true ->
          politician = Enum.find(politicians, &(&1.id == politician_id))

          socket
          |> assign(:selected_all, false)
          |> assign(
            :selected_party_id,
            if(election.type == :parliamentary, do: politician.party_id, else: nil)
          )
          |> assign(:selected_town, if(election.type == :local, do: politician.town, else: nil))
          |> assign(:selected_politician_id, politician_id)
          |> assign_selected_statements()
      end

    {:noreply, socket}
  end

  # Used for all types of elections.
  @impl true
  def handle_event("select_all", _params, socket) do
    socket =
      socket
      |> assign(:selected_all, true)
      |> assign(:selected_party_id, nil)
      |> assign(:selected_town, nil)
      |> assign(:selected_politician_id, nil)
      |> assign_selected_statements()

    {:noreply, socket}
  end

  @impl true
  def handle_event(_event, _params, socket) do
    {:noreply, socket}
  end

  #
  # view functions
  #

  def filter_politicians_by_party(politicians, party_id) do
    if party_id != nil do
      Enum.filter(politicians, &(&1.party_id == party_id))
    else
      politicians
    end
  end

  def filter_politicians_by_town(politicians, town) do
    if town != nil do
      Enum.filter(politicians, &(&1.town == town))
    else
      politicians
    end
  end

  #
  # helpers
  #

  defp assign_selected_statements(socket) do
    %{
      statements: statements,
      selected_party_id: selected_party_id,
      selected_town: selected_town,
      selected_politician_id: selected_politician_id,
      selected_round: selected_round
    } = socket.assigns

    selected_statements =
      statements
      |> filter_statements_by_party(selected_party_id)
      |> filter_statements_by_town(selected_town)
      |> filter_statements_by_politician(selected_politician_id)
      |> filter_statements_by_round(selected_round)

    assign(socket, :selected_statements, selected_statements)
  end

  defp filter_statements_by_party(statements, party_id) do
    unless party_id == nil do
      Enum.filter(statements, &(&1.politician.party.id == party_id))
    else
      statements
    end
  end

  defp filter_statements_by_town(statements, town) do
    unless town == nil do
      Enum.filter(statements, &(&1.politician.town == town))
    else
      statements
    end
  end

  defp filter_statements_by_politician(statements, politician_id) do
    unless politician_id == nil do
      Enum.filter(statements, &(&1.politician.id == politician_id))
    else
      statements
    end
  end

  defp filter_statements_by_round(statements, round) do
    unless round == nil do
      Enum.filter(statements, &(&1.round == round))
    else
      statements
    end
  end
end
