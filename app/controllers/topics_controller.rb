class TopicsController < ApplicationController
  before_action :authenticate_user! #ログインしてなかったらログイン画面に自動的に遷移
  before_action :set_topic, only: [:show, :edit, :update, :destroy]

  def index
    @topics = Topic.includes(:user).all
  end

  def new
    @topic = Topic.new
    @user = current_user
  end

  def create
    @topic = Topic.new(topic_params)
    if @topic.save
      flash[:notice] = t('.created')
      redirect_to topics_path
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
    redirect_to admin_topics_path
  end

  private

  def topic_params #:portraitを追加、モデルはhas_many_attached :portrait
    params.require(:topic).permit(:title, :content, :user_id, :company_id)
  end

  def set_topic #今回は人のトピックも見ることができる
    @topic = Topic.find_by(id: params[:id])
  end


end
