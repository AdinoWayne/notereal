defmodule Notereal.PostController do
    use Notereal.Web, :controller

    alias Ecto.Multi
    alias Notereal.Post
    alias Notereal.PostView
    alias Notereal.Tag
    alias Notereal.Post_Tag

    def index(conn, _params) do
        case Repo.all(Post) do
            post -> 
                json(conn, %{ success: true, result: PostView.render_many("posts_list.json", post)})
            nil ->
                json(conn, %{ success: false, message: "Get Error"})
        end
    end

    def show(conn, %{"id" => id}) do
        {id, _ } = Integer.parse(id)
        changeset = Repo.get!(Post, id)
        case changeset do
            _ -> 
                json(conn, %{ success: true, result: PostView.render("posts.json", changeset)})
            nil -> 
                json(conn, %{ success: false, message: "Nothing"})
        end
    end

    def create(conn, %{"posts" => value}) do
        list = value["tag"]
        params = Map.delete(value, "tag")
        multi = 
            Multi.new()
                |> Multi.run(:new_post, fn _ -> 
                    %Post{}
                    |> Post.changeset(params)
                    |> Repo.insert()
                end)
                |> Multi.run(:new_result, fn %{new_post: new_post} -> 
                    for item <- list do
                        case tag_id = Repo.one(from(t in Tag, where: t.tag == ^item)) do
                            nil ->
                                IO.inspect("Try it wrong")
                            _ ->
                                elem = %{
                                    tag_id: tag_id.id,
                                    post_id: new_post.id
                                }
                                %Post_Tag{}
                                |> Post_Tag.changeset(elem)
                                |> Repo.insert()
                            
                        end
                    end
                end)
        case Repo.transaction(multi) do
            {:ok, result } ->
                json(conn, %{ success: true, result: PostView.render("posts.json", result)})
    
            {:error, err } ->
                json(conn, %{ success: false, message: "Nothing"})
        end
    end

    def update(conn, %{"id" => id, "posts" => value}) do
        old_info = Repo.get(Post, id)
        changeset = Post.changeset(old_info, value)
        case Repo.update(changeset) do
            {:ok, post} ->
                json(conn, %{ success: true, result: PostView.render("posts.json", post)})
            {:error, _ } -> 
                json(conn, %{ success: false, message: "Update error"})
        end
    end

    def delete(conn, %{"id" => id}) do
        {id, _ } = Integer.parse(id)
        case Repo.get!(Post, id) |> Repo.delete! do
            _ -> 
                json(conn, %{ success: true, message: "Delete successfully"})
            nil -> 
                json(conn, %{ success: false, message: "delete failed"})
        end
    end
end