defmodule LzhWeb.ElectionLive.Show do
  use LzhWeb, :live_view

  alias Lzh.{Elections, Statements}

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    election = Elections.get_election!(id)

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
      |> assign(:page_title, "Избори")
      |> assign(:selected_party_id, nil)
      |> assign(:selected_politician_id, nil)
      |> assign(:selected_statements, statements)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    %{politicians: politicians, parties: parties, statements: statements} = socket.assigns

    selected_politician_id = determine_id(params, "politician", politicians)
    selected_party_id = determine_id(params, "party", parties)

    selected_statements =
      statements
      |> Enum.filter(fn statement ->
        selected_politician_id == nil or statement.politician.id == selected_politician_id
      end)
      |> Enum.filter(fn statement ->
        selected_party_id == nil or statement.politician.party.id == selected_party_id
      end)

    socket =
      socket
      |> assign(:selected_politician_id, selected_politician_id)
      |> assign(:selected_party_id, selected_party_id)
      |> assign(:selected_statements, selected_statements)

    {:noreply, socket}
  end

  defp determine_id(params, key, list) do
    with %{^key => string_id} <- params,
         {id, ""} <- Integer.parse(string_id),
         true <- Enum.any?(list, fn item -> item.id == id end) do
      id
    else
      _ -> nil
    end
  end
end