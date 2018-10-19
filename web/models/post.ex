defmodule Notereal.Post do
    use Notereal.Web, :model
    use Ecto.Schema

    alias Notereal.User
    alias Notereal.Tag
    alias Notereal.Post_Tag
    # plug Discuss.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]

    schema "posts" do
        field :title, :string
        field :content, :string
        field :vote, :string
        belongs_to(:user, User, foreign_key: :user_id)
        many_to_many :tags, Tag, join_through: "posts_tags"
        has_many :posts_tags, Post_Tag
        timestamps()
    end

    def changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:title, :content, :vote, :user_id])
        |> validate_required([:title, :content])
    end

end
