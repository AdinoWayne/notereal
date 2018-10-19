defmodule Notereal.PostView do
    use Notereal.Web, :view

    def render("post_just_loaded.json", posts) do
        Map.take(posts, [
          :id,
          :title,
          :content,
          :vote,
          :inserted_at,
          :updated_at,
          :user_id
        ])
    end

    def render("posts.json", posts) do
        data = render("posts_just_loaded.json", posts)
    end

    def render_many("posts_list.json", posts) do
        Enum.map(posts, &render("posts.json", &1))
    end

    def render("show.json", %{posts: posts}) do
        %{data: render_one(posts, PostView, "post_show.json")}
    end

    def render("post_show.json", %{posts: posts}) do
        %{id: posts.id, title: posts.title, content: posts.content, vote: posts.vote, inserted_at: posts.inserted_at, updated_at: posts.updated_at, user_id: posts.user_id}
    end

end
  