defmodule Notereal.PostController do
    use Notereal.Web, :controller

    alias Ecto.Multi
    alias Notereal.Post
    alias Notereal.PostView
    alias Notereal.Tag
    alias Notereal.Post_Tag

    def index(conn, %{"limit" => limit, "offset" => offset }) do
        case Repo.all(from(p in Post,join: a in Post_Tag, on: p.id == a.post_id,join: t in Tag, on: a.tag_id == t.id, select: {p, fragment("array_to_string(array_agg(?), ', ')", t.tag)}, limit: ^limit, offset: ^offset, group_by: p.id)) do
            post -> 
                json(conn, %{ success: true, result: PostView.render_many("posts_list.json", post)})
            nil ->
                json(conn, %{ success: false, message: "Get Error"})
        end
    end

    def show(conn, %{"id" => id}) do
        {id, _ } = Integer.parse(id)
        changeset = Repo.get(Post, id)
        case changeset do
            nil -> 
                json(conn, %{ success: false, message: "Nothing"})
            _ -> 
                json(conn, %{ success: true, result: PostView.render("posts.json", changeset)})
        end
    end

    def create(conn, %{"posts" => value}) do
        list = value["tag"]
        list_tag = Repo.all(from(t in Tag, where: t.id in ^list))
        params = Map.delete(value, "tag")    
        multi = 
            Multi.new()
                |> Multi.run(:new_post, fn _ -> 
                    %Post{}
                    |> Post.changeset(params)
                    |> Repo.insert()
                end)
                |> Multi.run(:new_result, fn %{new_post: new_post} -> 
                    link_post_to_tags(new_post.id, list_tag |> Enum.map(fn tag -> tag.id end))
                end)
        case Repo.transaction(multi) do
            {:ok, %{new_post: post} } ->
                json(conn, %{ success: true, message: "successfully" })
            {:error, err } ->
                json(conn, %{ success: false, message: "Nothing"})
        end
    end

    def link_post_to_tags(post_id, tag_ids) do
        result = Repo.insert_all(
            Post_Tag,
            tag_ids |> Enum.map(fn tag_id -> %{post_id: post_id, tag_id: tag_id} end),
            returning: true
        )
        if result |> elem(0) == length(tag_ids) do
                {:ok, result |> elem(1)}
            else
                {:error, nil}
            end
    end

    def link_post_to_tags(_, _), do: {:error, :api_bad_request}

    def update(conn, %{"id" => id, "posts" => value}) do
        list = value["tag"]
        list_tag = Repo.all(from(t in Tag, where: t.id in ^list))
        {id, _ } = Integer.parse(id)
        params = Map.delete(value, "tag")
        multi = 
            Multi.new()
                |> Multi.run(:delete, fn _ -> 
                    delete_connect_post_tag(id)
                end)
                |> Multi.run(:create, fn _ -> 
                    link_post_to_tags(id, list_tag |> Enum.map(fn item -> item.id end))
                end)
                |> Multi.run(:update_post, fn _ -> 
                    old_info = Repo.get(Post, id)
                    changeset = Post.changeset(old_info, params)
                    Repo.update(changeset)
                end)
        case Repo.transaction(multi)  do
            {:ok, %{update_post: update_post}} ->
                json(conn, %{ success: true, result: PostView.render("posts.json", update_post)})
            {:error, _ } -> 
                json(conn, %{ success: false, message: multi})
        end
    end

    def delete_connect_post_tag(post_id) do
        query = from(b in Post_Tag, where: b.post_id == ^post_id)
        if result = query |> Repo.delete_all() do
            {:ok, result |> elem(1)}
        else
            {:error, nil }
        end
        
    end

    def delete(conn, %{"id" => id}) do
        {id, _ } = Integer.parse(id)
        multi =
            Multi.new()
                |>Multi.run(:delete_tag, fn _ -> 
                    delete_connect_post_tag(id)
                end)
                |>Multi.run(:delete_post, fn _ -> 
                    Repo.get(Post, id) |> Repo.delete()
                end)

        case Repo.transaction(multi) do
            {:ok, %{delete_post: delete_post} }-> 
                json(conn, %{ success: true, message: "Delete successfully"})
            {:error, err } -> 
                json(conn, %{ success: false, message: "delete failed"})
        end
    end
end