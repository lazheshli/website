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
        socket
        |> assign(:selected_all, false)
        |> assign(:selected_party_id, toggled_party_id)
        |> assign(:selected_politician_id, nil)
        |> assign(
          :selected_statements,
          Enum.filter(statements, &(&1.politician.party.id == toggled_party_id))
        )
      end

    {:noreply, socket}
  end

  @impl true
  def handle_event("toggle_town", %{"town" => toggled_town}, socket) do
    %{selected_town: selected_town, statements: statements} = socket.assigns

    socket =
      if toggled_town == selected_town do
        socket
        |> assign(:selected_all, true)
        |> assign(:selected_town, nil)
        |> assign(:selected_politician_id, nil)
        |> assign(:selected_statements, statements)
      else
        socket
        |> assign(:selected_all, false)
        |> assign(:selected_town, toggled_town)
        |> assign(:selected_politician_id, nil)
        |> assign(
          :selected_statements,
          Enum.filter(statements, &(&1.politician.town == toggled_town))
        )
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
        |> assign(:selected_town, nil)
        |> assign(:selected_politician_id, nil)
        |> assign(:selected_statements, statements)
      else
        socket
        |> assign(:selected_all, false)
        |> assign(:selected_party_id, nil)
        |> assign(:selected_town, nil)
        |> assign(:selected_politician_id, toggled_politician_id)
        |> assign(
          :selected_statements,
          Enum.filter(statements, &(&1.politician.id == toggled_politician_id))
        )
      end

    {:noreply, socket}
  end

  @impl true
  def handle_event("select_round", %{"round" => round}, socket) do
    %{statements: statements} = socket.assigns

    round = String.to_integer(round)

    socket =
      if round == 0 do
        socket
        |> assign(:selected_round, nil)
      else
        socket
        |> assign(:selected_round, round)
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
        socket
        |> assign(:selected_all, false)
        |> assign(:selected_party_id, party_id)
        |> assign(:selected_politician_id, nil)
        |> assign(
          :selected_statements,
          Enum.filter(statements, &(&1.politician.party.id == party_id))
        )
      end

    {:noreply, socket}
  end

  @impl true
  def handle_event("select_town", %{"town" => town}, socket) do
    %{statements: statements} = socket.assigns

    socket =
      if town == "-" do
        socket
        |> assign(:selected_all, true)
        |> assign(:selected_town, nil)
        |> assign(:selected_politician_id, nil)
        |> assign(:selected_statements, statements)
      else
        socket
        |> assign(:selected_all, false)
        |> assign(:selected_town, town)
        |> assign(:selected_politician_id, nil)
        |> assign(:selected_statements, Enum.filter(statements, &(&1.politician.town == town)))
      end

    {:noreply, socket}
  end

  @impl true
  def handle_event("select_politician", %{"politician" => politician_id}, socket) do
    %{
      election: election,
      politicians: politicians,
      statements: statements,
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
          |> assign(
            :selected_statements,
            Enum.filter(statements, &(&1.politician.party_id == selected_party_id))
          )

        politician_id == 0 and election.type == :local and selected_town != nil ->
          socket
          |> assign(:selected_all, false)
          |> assign(:selected_politician_id, nil)
          |> assign(
            :selected_statements,
            Enum.filter(statements, &(&1.politician.town == selected_town))
          )

        politician_id == 0 ->
          socket
          |> assign(:selected_all, true)
          |> assign(:selected_party_id, nil)
          |> assign(:selected_town, nil)
          |> assign(:selected_politician_id, nil)
          |> assign(:selected_statements, statements)

        true ->
          politician = Enum.find(politicians, &(&1.id == politician_id))

          socket
          |> assign(:selected_all, false)
          |> assign(:selected_party_id, politician.party_id)
          |> assign(:selected_town, politician.town)
          |> assign(:selected_politician_id, politician_id)
          |> assign(
            :selected_statements,
            Enum.filter(statements, &(&1.politician.id == politician_id))
          )
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
      |> assign(:selected_town, nil)
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

  def filter_by_town(politicians, town) when is_binary(town) do
    Enum.filter(politicians, &(&1.town == town))
  end

  def filter_by_town(politicians, nil) do
    politicians
  end
end
