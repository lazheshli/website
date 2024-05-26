defmodule LzhWeb.Admin.HomeLive do
  use LzhWeb, :admin_live_view

  def render(%{} = assigns) do
    ~H"""
    <.h1>Welcome!</.h1>
    """
  end
end
