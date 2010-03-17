module UsersHelper
  def user_link(user)
    returning "" do |str|
      str << link_to(user.name, username_path(user.username))
      link = ' (' + link_to(user.username, username_path(user.username)) + ')'
      str << content_tag(:span, link, :class => 'light')
    end
  end
end
