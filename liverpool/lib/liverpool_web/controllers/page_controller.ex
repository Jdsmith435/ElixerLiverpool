defmodule LiverpoolWeb.PageController do
  use LiverpoolWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
