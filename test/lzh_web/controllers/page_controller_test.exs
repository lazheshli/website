defmodule LzhWeb.PageControllerTest do
  use LzhWeb.ConnCase

  import Lzh.ElectionsFixtures

  test "GET /", %{conn: conn} do
    election_fixture()
    election_fixture()

    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Лъжеш ли?"
  end
end
