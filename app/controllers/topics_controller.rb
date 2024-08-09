class TopicsController < ApplicationController
  before_action :authenticate_user! #ログインしてなかったらログイン画面に自動的に遷移
  before_action :set_topic, only: [:show]
  before_action :topic_edit, only:[:edit, :update, :destroy]


  def index

    #検索ワードの中に文字が入っていたら、以下のif文に入る。
      if params[:q].present? && params[:q][:title_or_content_cont].present?
        search_word = params[:q][:title_or_content_cont]
        hiragana_search_word = Topic.to_hiragana(search_word)
        katakana_search_word = Topic.to_katakana(search_word)
        @q = Topic.ransack(m: "and", title_or_content_cont_any: [search_word, hiragana_search_word, katakana_search_word], genre_eq: params[:q][:genre_eq])
      else
        @q = Topic.joins(:user).ransack(params[:q])

      end
    @topics = @q.result.includes(:user, topic_images_attachments: :blob).order(created_at: :desc).page(params[:page]).per(9)
    # binding.irb
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
      #flash[:alert] = "トピックの作成に失敗しました"
      # binding.irb
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
      flash[:alert] = "更新に失敗しました"
      render :edit
    end
  end

  def destroy
    if @topic.topic_images.attached?
      if @topic.topic_images.purge && @topic.destroy
        flash[:notice] = t('.destroyed')
        redirect_to users_path
      else
        flash[:alert] = "削除に失敗しました"
        redirect_to users_path
      end
    else
      @topic.destroy
      flash[:notice] = t('.destroyed')
      redirect_to users_path
    end
  end

  private

  def topic_params #:topic_imageを追加、モデルはhas_many_attached :topic_image
    params.require(:topic).permit(:title, :content, :genre, :author_name, topic_images: []).merge(user_id: current_user.id, company_id: current_user.company_id)
  end

  def set_topic #今回は人のトピックも見ることができる
    @topic = Topic.find_by(id: params[:id])
  end

  def topic_edit #edit、update、destoryで他人が入れないようにする
    @topic = Topic.find_by(id: params[:id], user_id: current_user.id)
    unless @topic
      flash[:alert] = "ページのロードに失敗しました"
      redirect_to users_path
    end
  end



end
