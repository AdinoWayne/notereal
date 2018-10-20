defmodule Notereal.User do
    use Notereal.Web, :model

    alias Notereal.Post
    # plug Discuss.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]

    schema "users" do
        field :email, :string
        field :password, :string
        field :username, :string
        field :token, :string
        has_many(:post, Post, foreign_key: :user_id) 
        timestamps()
    end

    def changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:email, :password, :username, :token])
        |> validate_required([:email, :password, :username])
        |> unique_constraint(:username)
        |> hash_user_password()
    end
    defp hash_user_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
        change(changeset, password: Bcrypt.hash_pwd_salt(password))
    end

    defp hash_user_password(changeset) do
        changeset
    end
end
