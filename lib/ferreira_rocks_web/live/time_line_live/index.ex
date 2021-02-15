defmodule FerreiraRocksWeb.TimeLineLive.Index do
  use FerreiraRocksWeb, :live_view

  alias FerreiraRocks.Posts

  @env Mix.env()

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :posts, Posts.published())}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, assign(socket, :page_title, "TL")}
  end

  def format_date(date) do
    with {:ok, str} <- Timex.format(date, "{Mfull} {D}, {YYYY}"),
      do: str
  end
end
