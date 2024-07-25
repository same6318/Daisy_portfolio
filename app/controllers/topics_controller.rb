class TopicsController < ApplicationController
  before_action :authenticate_user! #ログインしてなかったらログイン画面に自動的に遷移
  before_action :set_topic, only: [:show, :edit, :update, :destroy]

  def index #viewから送られてくるパラメータを元にテーブルからデータを検索する
    @q = Topic.ransack(params[:q])
    @topics = @q.result(distinct: true).includes(:user).all
  end

  def new
    @topic = Topic.new
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
    @user = current_user
      if @user.company?
        @topic.author = @user.name
      elsif @user.screen_name?
        @topic_autor = @user.screen_name
      else
        @topic_autor = "匿名希望"
      end
    
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
    redirect_to topics_path
  end

  private

  def topic_params #:portraitを追加、モデルはhas_many_attached :portrait
    params.require(:topic).permit(:title, :content, :author_name).merge(user_id: current_user.id, company_id: current_user.company_id)
  end

  def set_topic #今回は人のトピックも見ることができる
    @topic = Topic.find_by(id: params[:id])
  end


end
