defmodule Notereal.TagController do
    use Notereal.Web, :controller

    alias Notereal.Tag
    alias Notereal.TagView

    def index(conn, _params) do
      case Repo.all(Tag) do
            post -> 
                json(conn, %{ success: true, result: TagView.render_many("tags_list.json", post) })
            nil -> 
                json(conn, %{ success: false, message: "Get error" })
      end
    end

    def show(conn, %{"id" => id}) do
        {id, _} = Integer.parse(id)
        changeset = Repo.get!(Tag, id)
        case changeset do
            _ ->
                json(conn, %{ success: true, result: TagView.render("tags.json", changeset) })
            nil ->
                json(conn, %{ success: false, message: "Nothing" })
        end
    end
    
    def create(conn,  %{"tags" => value}) do
        changeset = Tag.changeset(%Tag{}, value)
        case Repo.insert(changeset) do
            {:ok, post} -> 
                json(conn, %{ success: true, result: TagView.render("tags.json", post)})
            {:error, _ } -> 
                json(conn, %{ success: false, message: "Create error"})
        end
    end

    def update(conn, %{"id" => id, "tags" => value}) do
        old_info = Repo.get(Tag, id)
        changeset = Tag.changeset(old_info, value)
        case Repo.update(changeset) do
            {:ok, post} -> 
                json(conn, %{ success: true, result: TagView.render("tags.json", post)})
            {:error, _ } -> 
                json(conn, %{ success: false, message: "Create error"})
        end
    end

    def delete(conn, %{"id" => id}) do
        {id, _} = Integer.parse(id)
        case Repo.get!(Tag, id) |> Repo.delete! do
            _ ->
                json(conn, %{ success: true, message: "Delete Successfully" })
            nil ->
                json(conn, %{ success: false, message: "Delete Failed" })
        end
    end
end
  