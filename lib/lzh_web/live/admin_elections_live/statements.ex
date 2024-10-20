defmodule LzhWeb.Admin.ElectionsLive.Statements do
  use LzhWeb, :admin_live_view

  alias Lzh.{Elections, Statements}
  alias Statements.Statement

  @impl true
  def mount(%{"election" => election_id}, %{} = _assigns, socket) do
    election = Elections.get_election!(election_id)

    socket =
      socket
      |> assign(:election, election)
      |> assign(:order_by, :date)
      |> assign_statements()

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_live_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_info({:saved, _statement}, socket) do
    {:noreply, assign_statements(socket)}
  end

  #
  # event handlers
  #

  @impl true
  def handle_event("set_order_by", %{"key" => key}, socket) do
    order_by =
      case key do
        "date" -> :date
        "politician" -> :politician
      end

    socket =
      socket
      |> assign(:order_by, order_by)
      |> assign_statements()

    {:noreply, socket}
  end

  #
  # helpers
  #

  defp apply_live_action(socket, :edit, %{"statement" => id}) do
    socket
    |> assign(:page_title, "Редакция на твърдение")
    |> assign(:statement_for_form, Statements.get_statement!(id))
  end

  defp apply_live_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Ново твърдение")
    |> assign(:statement_for_form, %Statement{})
  end

  defp apply_live_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Твърдения")
    |> assign(:statement_for_form, nil)
  end

  defp assign_statements(socket) do
    statements =
      socket.assigns.election
      |> Statements.list_statements()
      |> sort_statements(socket.assigns.order_by)

    assign(socket, :statements, statements)
  end

  defp sort_statements(statements, :date) do
    Enum.sort_by(statements, & &1.date, Date)
  end

  defp sort_statements(statements, :politician) do
    Enum.sort_by(statements, & &1.avatar.politician.name)
  end
end
