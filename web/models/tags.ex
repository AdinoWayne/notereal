defmodule Notereal.Tag do
    use Notereal.Web, :model

    alias Notereal.Post
    alias Notereal.Post_Tag
    # plug Discuss.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]

    schema "tags" do
        field :tag, :string
        many_to_many :posts, Post, join_through: "posts_tags"
        has_many :posts_tags, Post_Tag
    end

    def changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:tag])
        |> validate_required([:tag])
        |> unique_constraint(:tag)
    end

end
