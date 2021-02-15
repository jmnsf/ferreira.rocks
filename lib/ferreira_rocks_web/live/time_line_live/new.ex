defmodule FerreiraRocksWeb.TimeLineLive.New do
  use FerreiraRocksWeb, :live_view

  alias FerreiraRocks.Posts
  alias FerreiraRocks.Schema.Post

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "New TL", changeset: Post.changeset(%Post{}, %{}))}
  end

  @impl true
  def handle_event("validate", %{"post" => params}, socket) do
    changeset =
      %Post{}
      |> Post.changeset(params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"post" => params}, socket) do
    case Posts.create(params) do
      {:ok, _post} ->
        {:noreply,
         socket
         |> put_flash(:info, "post created")
         |> redirect(to: Routes.time_line_index_path(socket, :index))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
