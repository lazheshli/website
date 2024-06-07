defmodule LzhWeb.Admin.StatementsLive.Index do
  use LzhWeb, :admin_live_view

  alias Lzh.{Elections, Statements}
  alias Statements.Statement

  @impl true
  def mount(%{} = _params, %{} = _assigns, socket) do
    # for now hard-coded
    election = Elections.get_election_by_slug("2024-юни-парламентарни-избори")

    socket =
      socket
      |> assign(:election, election)
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
  # helpers
  #

  defp apply_live_action(socket, :edit, %{"id" => id}) do
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
    socket
    |> assign(:statements, Statements.list_statements(socket.assigns.election))
  end
end
