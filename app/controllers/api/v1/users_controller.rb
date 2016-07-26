class Api::V1::UsersController < Api::V1::ApiController
  skip_before_action :check_api_key, only: :sign_in
  api! "인증 후 access token을 전달한다."
  param :username, String, desc: "사용자의 계정명(아이디)", required: true
  param :password, String, desc: "사용자의 비밀번호", required: true
  error code: 403, desc: "존재하지 않는 계정이거나 비밀번호가 일치하지 않는 경우"
  example <<-EOS
  {
    "access_token": "abcdef0123456789abcdef"
  }
  EOS
  def sign_in
    user = User.where(username: params[:username]).first
    if user and user.authenticate(params[:password])
      api_key = ApiKey.create(
        user_id: user.id
      )
      render json: {
        access_token: api_key.access_token
      }
    else
      render status: 403, json: {}
    end
  end
end