# frozen_string_literal: true

# Helper methods for user-related stuff
module UsersHelper
  # @param [User] user
  def my_user_link(user)
    img = image_tag(user.tiny_avatar_url, alt: '')
    text = user.text_for_link

    raw %(<a href="#{my_path}" class="profile-link"><span>#{img}</span> #{text}</a>)
  end

  # @param [User] user
  def user_link(user)
    img = image_tag(user.tiny_avatar_url, alt: '')
    text = user.text_for_link

    raw %(<a href="#{user.world_url}" class="profile-link"><span>#{img}</span> #{text}</a>)
  end
end
