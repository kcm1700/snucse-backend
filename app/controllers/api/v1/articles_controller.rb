class Api::V1::ArticlesController < Api::V1::ApiController
  api! "글 목록을 전달한다."
  example <<-EOS
  {
    "articles": [
      {"id": 1, "title": "title", ...},
      ...
    ]
  }
  EOS
  def index
    @articles = Article.all.includes(:group, :writer)
  end

  api! "글을 조회한다."
  example <<-EOS
  {
    "id": 1,
    "title": "title",
    "content": "content",
    "created_at": "2016-07-01T00:00:00.000Z",
    "updated_at": "2016-07-01T00:00:00.000Z",
    "group": {
      "id": 1,
      "name": "13학번 모임"
    },
    "writer": {
      "id": 1,
      "username": "writer",
      "name": "작성자",
      "profile_image_url": "http://placehold.it/100x100"
    }
  }
  EOS
  def show
    @article = Article.find params[:id]
  end

  api! "글을 생성한다."
  param :group_id, Integer, desc: "글이 작성되는 모임의 ID", required: true
  param :title, String, desc: "글 제목", required: true
  param :content, String, desc: "글 내용", required: true
  def create
    @article = Article.new(
      writer_id: @user.id,
      group_id: params[:group_id],
      title: params[:title],
      content: params[:content]
    )
    if @article.save
      render :show, status: :created
    else
      render json: @article.errors, status: :bad_request
    end
  end

  api! "글을 수정한다."
  param :title, String, desc: "글 제목", required: true
  param :content, String, desc: "글 내용", required: true
  error code: 401, desc: "자신이 작성하지 않은 글을 수정하려고 하는 경우"
  def update
    @article = Article.find params[:id]
    if @user != @article.writer
      render_unauthorized and return
    end
    if @article.update(
      title: params[:title],
      content: params[:content]
    )
      render :show
    else
      render json: @article.errors, sttatus: :bad_request
    end
  end

  api! "글을 삭제한다."
  error code: 401, desc: "자신이 작성하지 않은 글을 삭제하려고 하는 경우"
  def destroy
    @article = Article.find params[:id]
    if @user != @article.writer
      render_unauthorized and return
    end
    @article.destroy
    head :no_content
  end
end
