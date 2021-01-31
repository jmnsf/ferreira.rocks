defmodule FerreiraRocksWeb.PageLive do
  use FerreiraRocksWeb, :live_view

  alias FerreiraRocksWeb.PageView

  @pages ["now", "diary", "code"]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    socket =
      socket
      |> assign(:page, params["page"])
      |> assign_title(params["page"])

    {:noreply, socket}
  end

  @impl true
  def render(%{live_action: :index} = assigns) do
    PageView.render("index.html", assigns)
  end

  def render(%{live_action: :show, page: page} = assigns) when page in @pages do
    PageView.render("#{page}.html", assigns)
  end

  defp assign_title(socket, page) when page in @pages,
    do: assign(socket, :page_title, String.capitalize(page))

  defp assign_title(socket, _page),
    do: socket
end
