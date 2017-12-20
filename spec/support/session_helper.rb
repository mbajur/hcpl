module SessionHelper
  def sign_in(user)
    visit root_path

    create_cookie(:stub_user_id, user.id.to_s, path: '/', domain: "127.0.0.1")
  end
end
