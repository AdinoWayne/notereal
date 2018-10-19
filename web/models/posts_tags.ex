defmodule Notereal.Post_Tag do
    use Notereal.Web, :model

    alias Notereal.Post
    alias Notereal.Tag
    # plug Discuss.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]

    schema "posts_tags" do
        has_many :posts, Post
        has_many :tags, Tag
    end

    def changeset(struct, params \\ %{}) do
        struct
            |> put_assoc(:tag_id, get_tags(params["tags"]))
            |> put_assoc(:post_id, get_posts(params["posts"]))
    end

    def get_tags(params) do
        if id = params["id"] do
            Repo.get_by(Tag, id: id)
        end
    end

    def get_posts(params) do
        if id = params["id"] do
            Repo.get_by(Post, id: id)
        end
    end
end
