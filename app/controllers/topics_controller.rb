class TopicsController < ApplicationController
  before_action :authenticate_user! #ログインしてなかったらログイン画面に自動的に遷移
  before_action :set_topic, only: [:show, :edit, :update, :destroy]

  def index #viewから送られてくるパラメータを元にテーブルからデータを検索する
    if params[:q].present? && params[:q][:title_or_content_cont].present?
      search_word = params[:q][:title_or_content_cont]
      hiragana_search_word = Topic.to_hiragana(search_word)
      katakana_search_word = Topic.to_katakana(search_word)
      @q = Topic.joins(:user).ransack(m: "or", title_or_content_cont_any: [search_word, hiragana_search_word, katakana_search_word])
    else
      @q = Topic.joins(:user).ransack(params[:q])
    end
    
    @topics = @q.result(distinct: true).includes(:user, topic_images_attachments: :blob).all.order(created_at: :desc).page(params[:page]).per(9)
  end

  def new
    @topic = Topic.new
  end

  def create
    @topic = Topic.new(topic_params)
    if @topic.save
      flash[:notice] = t('.created')
      redirect_to topic_path(@topic)
    else
      flash[:notice] = "トピックの作成に失敗しました"
      render :new
    end
  end

  def show
    @user = @topic.user
  end

  def edit
    @user = current_user
  end

  def update
    if @topic.update(topic_params)
      flash[:notice] = t('.updated')
      redirect_to topic_path(@topic)
    else
      flash[:notice] = "更新に失敗しました"
      render :edit
    end
  end

  def destroy
    @topic.destroy
    flash[:notice] = t('.destroyed')
    redirect_to users_path
  end

  private

  def topic_params #:topic_imageを追加、モデルはhas_many_attached :topic_image
    params.require(:topic).permit(:title, :content, :author_name, topic_images: []).merge(user_id: current_user.id, company_id: current_user.company_id)
  end

  def set_topic #今回は人のトピックも見ることができる
    @topic = Topic.find_by(id: params[:id])
  end


end
