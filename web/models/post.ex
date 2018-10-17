defmodule Notereal.Post do
    use Notereal.Web, :model
    use Ecto.Schema

    alias Notereal.User
    alias Notereal.Tag
    # plug Discuss.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]

    schema "posts" do
        field :title, :string
        field :content, :string
        field :vote, :string
        belongs_to(:user, User, foreign_key: :user_id)
        many_to_many :tags, Tag, join_through: "posts_tags"
        timestamps()
    end

    def changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:email])
        |> validate_required([:tag])
        |> unique_constraint(:tag)
    end

end
