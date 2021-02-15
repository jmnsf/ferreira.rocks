defmodule FerreiraRocksWeb.TimeLineLive.Edit do
  use FerreiraRocksWeb, :live_view

  alias FerreiraRocks.{Posts, Repo}
  alias FerreiraRocks.Schema.Post

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok, assign(socket, page_title: "Edit TL", changeset: Post.changeset(Posts.get(id), %{}))}
  end

  @impl true
  def handle_event("validate", %{"post" => params}, socket) do
    changeset =
      socket.assigns.changeset
      |> Post.changeset(params)
      |> Map.put(:action, :update)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"post" => params}, socket) do
    IO.puts("LOG #{inspect params}")
    IO.puts("LOG #{inspect socket.assigns.changeset}")
    socket.assigns.changeset
    |> Post.changeset(params)
    |> Repo.update()
    |> case do
      {:ok, post} ->
        {:noreply,
          socket
           |> put_flash(:info, "Post saved.")
           |> assign(:changeset, Post.changeset(post, %{}))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
          socket
          |> assign(:changeset, changeset)
          |> put_flash(:error, "Couldn't save post...")}
    end
  end

  def handle_event("publish", _params, socket),
    do: update_published(socket, socket.assigns.changeset, DateTime.utc_now())

  def handle_event("unpublish", _params, socket),
    do: update_published(socket, socket.assigns.changeset, nil)

  defp update_published(socket, post, published_at) do
    post
    |> Post.changeset(%{published_at: published_at})
    |> Repo.update()
    |> case do
      {:ok, post} ->
        {:noreply,
          socket
          |> put_flash(:info, (
            if is_nil(published_at),
              do: "Post unpublished,",
              else: "Post published!"
          ))
          |> assign(changeset: Post.changeset(post, %{}))
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
