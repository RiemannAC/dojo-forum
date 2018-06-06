module PostsHelper
  def collect_btn(post)
    if post.is_collected?(current_user)
      # "a" 測試用
      link_to "Uncollect", uncollect_post_path(post), method: :post,remote: true, class: "btn btn-sm btn-default", id: "uncollect-#{@post.id}"
    else
      # "b" 測試用
      link_to "Collect", collect_post_path(post), method: :post,remote: true, class: "btn btn-sm btn-default", id: "collect-#{@post.id}"
    end
  end
  module_function :collect_btn
end
