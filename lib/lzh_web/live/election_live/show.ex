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

    avatars =
      statements
      |> Enum.map(fn statement -> statement.avatar end)
      |> Enum.into(MapSet.new())
      |> Enum.sort_by(& &1.politician.name)

    parties =
      avatars
      |> Enum.map(& &1.party)
      |> Enum.into(MapSet.new())
      |> Enum.sort()

    towns =
      avatars
      |> Enum.map(& &1.town)
      |> Enum.into(MapSet.new())
      |> Enum.sort()

    socket =
      socket
      |> assign(:election, election)
      |> assign(:avatars, avatars)
      |> assign(:parties, parties)
      |> assign(:towns, towns)
      |> assign(:statements, statements)
      |> assign(:in_two_rounds, Enum.any?(statements, &(&1.round == 2)))
      |> assign(:selected_all, true)
      |> assign(:selected_party, nil)
      |> assign(:selected_town, nil)
      |> assign(:selected_avatar, nil)
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
  def handle_event("toggle_party", %{"party" => toggled_party}, socket) do
    %{selected_party: selected_party} = socket.assigns

    socket =
      if toggled_party == selected_party do
        socket
        |> assign(:selected_all, true)
        |> assign(:selected_party, nil)
        |> assign(:selected_avatar, nil)
        |> assign_selected_statements()
      else
        socket
        |> assign(:selected_all, false)
        |> assign(:selected_party, toggled_party)
        |> assign(:selected_avatar, nil)
        |> assign_selected_statements()
      end

    {:noreply, socket}
  end

  # Used for local elections — :selected_party is not relevant.
  @impl true
  def handle_event("toggle_town", %{"town" => toggled_town}, socket) do
    %{selected_town: selected_town} = socket.assigns

    socket =
      if toggled_town == selected_town do
        socket
        |> assign(:selected_all, true)
        |> assign(:selected_town, nil)
        |> assign(:selected_avatar, nil)
        |> assign_selected_statements()
      else
        socket
        |> assign(:selected_all, false)
        |> assign(:selected_town, toggled_town)
        |> assign(:selected_avatar, nil)
        |> assign_selected_statements()
      end

    {:noreply, socket}
  end

  # Used for all types of elections.
  @impl true
  def handle_event("toggle_avatar", %{"avatar" => toggled_avatar}, socket) do
    %{selected_avatar: selected_avatar} = socket.assigns

    toggled_avatar = String.to_integer(toggled_avatar)

    socket =
      if toggled_avatar == selected_avatar do
        socket
        |> assign(:selected_all, true)
        |> assign(:selected_party, nil)
        |> assign(:selected_town, nil)
        |> assign(:selected_avatar, nil)
        |> assign_selected_statements()
      else
        socket
        |> assign(:selected_all, false)
        |> assign(:selected_party, nil)
        |> assign(:selected_town, nil)
        |> assign(:selected_avatar, toggled_avatar)
        |> assign_selected_statements()
      end

    {:noreply, socket}
  end

  # Used for local elections — :selected_party is not relevant.
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
      |> assign(:selected_avatar, nil)
      |> assign_selected_statements()

    {:noreply, socket}
  end

  # Used for parliamentary elections — :selected_town and :selected_round are
  # not relevant.
  @impl true
  def handle_event("select_party", %{"party" => party}, socket) do
    party = if(party == "-", do: nil, else: party)

    socket =
      socket
      |> assign(:selected_all, party == nil)
      |> assign(:selected_party, party)
      |> assign(:selected_avatar, nil)
      |> assign_selected_statements()

    {:noreply, socket}
  end

  # Used for local elections — :selected_party is not relevant.
  @impl true
  def handle_event("select_town", %{"town" => town}, socket) do
    town = if(town == "-", do: nil, else: town)

    socket =
      socket
      |> assign(:selected_all, town == nil)
      |> assign(:selected_town, town)
      |> assign(:selected_avatar, nil)
      |> assign_selected_statements()

    {:noreply, socket}
  end

  # Used for all types of elections.
  @impl true
  def handle_event("select_avatar", %{"avatar" => avatar_id}, socket) do
    %{
      election: election,
      avatars: avatars,
      selected_party: selected_party,
      selected_town: selected_town
    } = socket.assigns

    avatar_id = String.to_integer(avatar_id)

    socket =
      cond do
        avatar_id == 0 and election.type == :parliamentary and selected_party != nil ->
          socket
          |> assign(:selected_all, false)
          |> assign(:selected_avatar, nil)
          |> assign_selected_statements()

        avatar_id == 0 and election.type == :local and selected_town != nil ->
          socket
          |> assign(:selected_all, false)
          |> assign(:selected_avatar, nil)
          |> assign_selected_statements()

        avatar_id == 0 ->
          socket
          |> assign(:selected_all, true)
          |> assign(:selected_party, nil)
          |> assign(:selected_town, nil)
          |> assign(:selected_avatar, nil)
          |> assign_selected_statements()

        true ->
          avatar = Enum.find(avatars, &(&1.id == avatar_id))

          socket
          |> assign(:selected_all, false)
          |> assign(
            :selected_party,
            if(election.type == :parliamentary, do: avatar.party, else: nil)
          )
          |> assign(:selected_town, if(election.type == :local, do: avatar.town, else: nil))
          |> assign(:selected_avatar, avatar_id)
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
      |> assign(:selected_party, nil)
      |> assign(:selected_town, nil)
      |> assign(:selected_avatar, nil)
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

  def filter_avatars_by_party(avatars, party) do
    if party != nil do
      Enum.filter(avatars, &(&1.party == party))
    else
      avatars
    end
  end

  def filter_avatars_by_town(avatars, town) do
    if town != nil do
      Enum.filter(avatars, &(&1.town == town))
    else
      avatars
    end
  end

  #
  # helpers
  #

  defp assign_selected_statements(socket) do
    %{
      statements: statements,
      selected_party: selected_party,
      selected_town: selected_town,
      selected_avatar: selected_avatar,
      selected_round: selected_round
    } = socket.assigns

    selected_statements =
      statements
      |> filter_statements_by_party(selected_party)
      |> filter_statements_by_town(selected_town)
      |> filter_statements_by_avatar(selected_avatar)
      |> filter_statements_by_round(selected_round)

    assign(socket, :selected_statements, selected_statements)
  end

  defp filter_statements_by_party(statements, party) do
    unless party == nil do
      Enum.filter(statements, &(&1.avatar.party == party))
    else
      statements
    end
  end

  defp filter_statements_by_town(statements, town) do
    unless town == nil do
      Enum.filter(statements, &(&1.avatar.town == town))
    else
      statements
    end
  end

  defp filter_statements_by_avatar(statements, avatar_id) do
    unless avatar_id == nil do
      Enum.filter(statements, &(&1.avatar.id == avatar_id))
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
