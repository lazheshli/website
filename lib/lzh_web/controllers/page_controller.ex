defmodule LzhWeb.PageController do
  use LzhWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
