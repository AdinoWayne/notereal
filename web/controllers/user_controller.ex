defmodule Notereal.UserController do
    use Notereal.Web, :controller

    alias Notereal.User
    alias Notereal.UserView
    alias Notereal.Guardian
    def index(conn, _params) do
      case Repo.all(User) do
            post -> 
                json(conn, %{ success: true, result: UserView.render_many("users_list.json", post) })
            nil -> 
                json(conn, %{ success: false, message: "Get error" })
      end
    end

    def show(conn, %{"id" => id}) do
        {id, _} = Integer.parse(id)
        changeset = Repo.get!(User, id)
        case changeset do
            _ ->
                json(conn, %{ success: true, result: UserView.render("users.json", changeset) })
            nil ->
                json(conn, %{ success: false, message: "Nothing" })
        end
    end
    
    def create(conn,  %{"users" => value}) do
        changeset = User.changeset(%User{}, value)
        case Repo.insert(changeset) do
            {:ok, post} -> 
                json(conn, %{ success: true, result: UserView.render("users.json", post)})
            {:error, _ } -> 
                json(conn, %{ success: false, message: "Create error"})
        end
    end

    def update(conn, %{"id" => id, "users" => value}) do
        old_info = Repo.get(User, id)
        changeset = User.changeset(old_info, value)
        case Repo.update(changeset) do
            {:ok, post} -> 
                json(conn, %{ success: true, result: UserView.render("users.json", post)})
            {:error, _ } -> 
                json(conn, %{ success: false, message: "Update error"})
        end
    end

    def delete(conn, %{"id" => id}) do
        {id, _} = Integer.parse(id)
        case Repo.get!(User, id) |> Repo.delete! do
            _ ->
                json(conn, %{ success: true, message: "Delete Successfully" })
            nil ->
                json(conn, %{ success: false, message: "Delete Failed" })
        end
    end

    def login(conn, %{"user" => params }) do
        
    end
end
  