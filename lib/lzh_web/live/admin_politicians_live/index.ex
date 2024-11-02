defmodule LzhWeb.Admin.PoliticiansLive.Index do
  use LzhWeb, :admin_live_view

  alias Lzh.{Elections, Politicians, Statements}
  alias Lzh.Politicians.Politician

  @impl true
  def mount(%{} = _params, %{} = _assigns, socket) do
    socket =
      socket
      |> assign(:order_by, :name)
      |> assign_politicians()

    {:ok, socket}
  end

  @impl true
  def handle_params(%{} = params, _url, socket) do
    socket = apply_live_action(socket, socket.assigns.live_action, params)

    {:noreply, socket}
  end

  @impl true
  def handle_info({:saved, _politician}, socket) do
    {:noreply, assign_politicians(socket)}
  end

  #
  # event handlers
  #

  @impl true
  def handle_event("set_order_by", %{"key" => key}, socket) do
    order_by =
      case key do
        "name" -> :name
        "num_statements" -> :num_statements
      end

    socket =
      socket
      |> assign(:order_by, order_by)
      |> assign_politicians()

    {:noreply, socket}
  end

  @impl true
  def handle_event("delete", %{"id" => politician_id}, socket) do
    {:ok, politician} =
      politician_id
      |> Politicians.get_politician!()
      |> Politicians.delete_politician()

    socket =
      socket
      |> assign_politicians()
      |> put_flash(:info, "#{politician.name} вече не цапа базата ни данни.")

    {:noreply, socket}
  end

  #
  # view functions
  #

  def election_name(%{} = election) do
    name = Elections.election_name(election)
    month_name = Elections.election_month_name(election)

    "#{String.downcase(name)} #{month_name} #{election.date.year}"
  end

  #
  # helpers
  #

  defp assign_politicians(socket) do
    politicians =
      Politicians.list_politicians()
      |> Enum.map(fn politician ->
        politician
        |> Map.put(:avatars, Politicians.list_avatars(politician))
        |> Map.put(:num_statements, Statements.count_statements(politician))
      end)
      |> sort_politicians(socket.assigns.order_by)

    assign(socket, :politicians, politicians)
  end

  defp sort_politicians(politicians, :name) do
    Enum.sort_by(politicians, & &1.name)
  end

  defp sort_politicians(politicians, :num_statements) do
    Enum.sort_by(politicians, & &1.num_statements, :desc)
  end

  defp apply_live_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Политици")
    |> assign(:politician_for_form, nil)
  end

  defp apply_live_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Нов политик")
    |> assign(:politician_for_form, %Politician{})
  end
end
