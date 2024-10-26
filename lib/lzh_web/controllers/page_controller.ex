defmodule LzhWeb.PageController do
  use LzhWeb, :controller

  alias Lzh.Elections

  plug :assign_year_elections
  plug :assign_action

  def home(conn, _params) do
    [election, last_election] = Enum.take(Elections.list_elections(), 2)

    conn
    |> assign(:election, election)
    |> assign(:last_election, last_election)
    |> assign(:page_title, "Начало")
    |> render(:home)
  end

  def about(conn, _params) do
    conn
    |> assign(:page_title, "За проекта")
    |> render(:about)
  end

  def election(conn, %{"slug" => slug}) do
    election = Elections.get_election_by_slug(slug)

    conn
    |> assign(:election, election)
    |> assign(:page_title, "#{election.name} (#{election.month_name} #{election.date.year})")
    |> render(:election)
  end

  def methodology(conn, _params) do
    conn
    |> assign(:page_title, "Методика")
    |> render(:methodology)
  end

  def team(conn, _params) do
    conn
    |> assign(:page_title, "Екип")
    |> render(:team)
  end

  def faq(conn, _params) do
    conn
    |> assign(:page_title, "Често задавани въпроси")
    |> render(:faq)
  end

  def privacy_policy(conn, _params) do
    conn
    |> assign(:page_title, "Политика за поверителност")
    |> render(:privacy_policy)
  end

  def disclaimer(conn, _params) do
    conn
    |> assign(:page_title, "Отказ от отговорност")
    |> render(:disclaimer)
  end

  #
  # plugs
  #

  defp assign_year_elections(conn, _opts) do
    conn
    |> assign(:year_elections, Elections.list_year_elections())
    |> assign(:election, nil)
  end

  defp assign_action(conn, _opts) do
    conn
    |> assign(:action, action_name(conn))
  end
end
