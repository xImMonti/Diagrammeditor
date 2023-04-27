defmodule DiagrammeditorWeb.PageController do
  use DiagrammeditorWeb, :controller

  def home(conn, _params) do
    redirect(conn, to: ~p"/processes")
  end
end
