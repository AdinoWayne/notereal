defmodule Notereal.TagView do
    use Notereal.Web, :view

    def render("tags_just_loaded.json", tag) do
        Map.take(tag, [
          :id,
          :tag,
        ])
    end

    def render("tags.json", tag) do
        data = render("tags_just_loaded.json", tag)
    end

    def render_many("tags_list.json", tag) do
        Enum.map(tag, &render("tags.json", &1))
    end

    def render("show.json", %{tag: tag}) do
        %{data: render_one(tag, TagView, "tag_show.json")}
    end

    def render("tag_show.json", %{tag: tag}) do
        %{id: tag.id, tag: tag.tag}
    end

end
  