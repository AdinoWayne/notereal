defmodule Notereal.Post_Tag do
    use Notereal.Web, :model

    alias Notereal.Post
    alias Notereal.Tag
    alias Notereal.Repo
    # plug Discuss.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]

    schema "posts_tags" do
        belongs_to(:posts, Post, foreign_key: :post_id) 
        belongs_to(:tags, Tag, foreign_key: :tag_id) 
    end

    def changeset(struct, params \\ %{}) do
        struct
            |> cast(params, [:tag_id, :post_id])
            # |> put_assoc(:tags, params["tag_id"], required: true)
            # |> put_assoc(:posts, params["post_id"], required: true)
    end
end
