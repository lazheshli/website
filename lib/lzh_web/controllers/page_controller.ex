defmodule LzhWeb.PageController do
  use LzhWeb, :controller

  def home(conn, _params) do
    conn
    |> assign(:page_title, "Начало")
    |> render(:home)
  end

  def about(conn, _params) do
    conn
    |> assign(:page_title, "За проекта")
    |> render(:about)
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
end
