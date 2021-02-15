defmodule FerreiraRocks.Posts do
  import Ecto.Query, only: [from: 2]

  alias FerreiraRocks.Repo
  alias FerreiraRocks.Schema.Post

  def all do
    Repo.all(Post)
  end

  def published do
    Repo.all(from(p in Post, where: not is_nil(p.published_at)))
  end

  def create(params) do
    %Post{}
    |> Post.changeset(params)
    |> Repo.insert()
  end

  def get(id) do
    Repo.get(Post, id)
  end
end
