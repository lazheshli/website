defmodule LzhWeb.Admin.ElectionsLive.StatementForm do
  use LzhWeb, :live_component

  alias Lzh.{Politicians, Statements}

  #
  # life cycle
  #

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(%{action: action, statement: statement, election: election}, socket) do
    changeset = Statements.change_statement(statement)

    socket =
      socket
      |> assign(:election, election)
      |> assign(:statement, statement)
      |> assign(:action, action)
      |> assign(:avatars_for_select, list_avatars_for_select(election))
      |> assign_form(changeset)

    {:ok, socket}
  end

  #
  # event handlers
  #

  @impl true
  def handle_event("validate", %{"statement" => params}, socket) do
    params = Map.put(params, "sources", string_to_array(params["sources"]))

    changeset =
      socket.assigns.statement
      |> Statements.change_statement(params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  @impl true
  def handle_event("save", %{"statement" => statement_params}, socket) do
    save(socket, socket.assigns.action, statement_params)
  end

  #
  # helpers
  #

  defp list_avatars_for_select(election) do
    election
    |> Politicians.list_avatars()
    |> Enum.into(Keyword.new(), fn avatar ->
      {"#{avatar.politician.name} (#{avatar.party})", avatar.id}
    end)
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp save(socket, :new, params) do
    election = socket.assigns.election

    params =
      params
      |> Map.put("election_id", socket.assigns.election.id)
      |> Map.put("sources", string_to_array(params["sources"]))

    socket =
      case Statements.create_statement(params) do
        {:ok, statement} ->
          notify_parent({:saved, statement})

          socket
          |> put_flash(:info, "Новото твърдение е добавено.")
          |> push_patch(to: ~p"/админ/избори/#{election.id}/твърдения", replace: true)

        {:error, changeset} ->
          assign_form(socket, changeset)
      end

    {:noreply, socket}
  end

  defp save(socket, :edit, params) do
    election = socket.assigns.election

    params =
      params
      |> Map.put("sources", string_to_array(params["sources"]))

    socket =
      case Statements.update_statement(socket.assigns.statement, params) do
        {:ok, statement} ->
          notify_parent({:saved, statement})

          socket
          |> put_flash(:info, "Твърдението е запазено.")
          |> push_patch(to: ~p"/админ/избори/#{election.id}/твърдения", replace: true)

        {:error, changeset} ->
          assign_form(socket, changeset)
      end

    {:noreply, socket}
  end

  defp string_to_array(string) do
    string
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.filter(fn line -> line != "" end)
  end

  defp array_to_string(nil), do: nil

  defp array_to_string(array) do
    Enum.join(array, "\n\n")
  end

  defp notify_parent(message) do
    send(self(), message)
  end
end
