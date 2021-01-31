IO.inspect(
  :mnesia.create_table(:posts, [
    disc_copies: [node()],
    record_name: FerreiraRocks.Schema.Post,
    attributes: [:id, :title, :format, :content, :published_at, :inserted_at, :updated_at],
    type: :set
  ])
)

IO.inspect(
  :mnesia.transform_table(
    :posts,
    fn post -> Map.put(post, :location, "somewhere") end,
    [:id, :title, :format, :content, :published_at, :inserted_at, :updated_at, :location]
  )
)
