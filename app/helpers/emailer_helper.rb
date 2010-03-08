module EmailerHelper
  def quizdoo_help_link(plain = false)
    url = 'http://help.quizdoo.com'
    return url if plain
    link_to url, url
  end
  
  def password_reset_link(plain = false)
    url = edit_password_reset_url @user.perishable_token,
                                  :host => 'quizdoo.com',
                                  :protocol => 'http'
    return url if plain
    link_to url, url
  end
end