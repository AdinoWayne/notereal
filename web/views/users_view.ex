defmodule Notereal.UserView do
    use Notereal.Web, :view

    def render("users_just_loaded.json", users) do
        Map.take(users, [
          :id,
          :email,
          :username,
          :password,
          :inserted_at,
          :updated_at,
          :token
        ])
    end

    def render("users.json", users) do
        data = render("users_just_loaded.json", users)
    end

    def render_many("users_list.json", users) do
        Enum.map(users, &render("users.json", &1))
    end

    def render("show.json", %{user: user}) do
        %{data: render_one(user, UserView, "user_show.json")}
    end

    def render("user_show.json", %{user: user}) do
        %{id: user.id, username: user.username, email: user.email, created_at: user.created_at, updated_at: user.updated_at}
    end

end
  