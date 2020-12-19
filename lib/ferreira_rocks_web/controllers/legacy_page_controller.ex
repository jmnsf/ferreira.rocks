defmodule FerreiraRocksWeb.LegacyPageController do
  use FerreiraRocksWeb, :controller

  def index(conn, _) do
    render(conn, "index.html", page_title: "Home")
  end

  def show(conn, %{"page" => "now.html"}) do
    render(conn, "now.html", page_title: "Now")
  end

  def show(conn, %{"page" => "diary.html"}) do
    render(conn, "diary.html", page_title: "Diary")
  end

  def show(conn, %{"page" => "code.html"}) do
    render(conn, "code.html", page_title: "Code")
  end
end
