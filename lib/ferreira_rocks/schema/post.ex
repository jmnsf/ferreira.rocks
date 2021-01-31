defmodule FerreiraRocks.Schema.Post do
  use FerreiraRocks.Schema

  schema "posts" do
    field :title
    field :content
    field :format, :string, default: "html"
    field :location, :string, default: "somewhere"

    field :published_at, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :format, :content, :published_at, :location])
    |> validate_required([:title, :format, :content])
    |> validate_inclusion(:format, ["html"])
  end
end
