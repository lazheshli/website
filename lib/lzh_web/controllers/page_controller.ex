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

  def faq(conn, _params) do
    conn
    |> assign(:page_title, "Често задавани въпроси")
    |> render(:faq)
  end
end
