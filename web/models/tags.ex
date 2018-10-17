defmodule Notereal.Tag do
    use Notereal.Web, :model

    alias Notereal.Post
    # plug Discuss.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]

    schema "tags" do
        field :tag, :string

        many_to_many :posts, Post, join_through: "posts_tags"
    end

    def changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:email])
        |> validate_required([:tag])
        |> unique_constraint(:tag)
    end

end
