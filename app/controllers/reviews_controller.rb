class ReviewsController < ApplicationController
  #before_action :business_user?, only: [:new, :create, :edit, :update, :destroy]
  before_action :authenticate_user! #ログインしてなかったらログイン画面に自動的に遷移
  before_action :set_review, only: [:show, :edit, :update, :destroy]

  def index
    @reviews = Review.includes(:user).all
  end

  def new
    @user = current_user
    @company = Company.find_by(id: params[:id]) #企業一覧ページから選択した企業IDを取得したい
    @review = @company.reviews.build
  end

  def create
    @review = @company.reviews.build(review_params)
    @review.user = current_user
    if @review.save
      flash[:notice] = t('.created')
      redirect_to review_path(@review)
    else
      flash[:notice] = "レビューの作成に失敗しました"
      render :new
    end
  end

  def show
    @user = @review.user
    @company = @review.company
  end

  def edit
  end

  def update
    if @review.update(review_params)
      flash[:notice] = t('.updated')
      redirect_to reviews_path
    else
      flash[:notice] = "更新に失敗しました"
      render :edit
    end
  end

  def destroy
    @review.destroy
    flash[:notice] = t('.destroyed')
    redirect_to admin_reviews_path
  end


  private

  def review_params #:company_portrait? modelにも[has_many_attached]必要
    params.require(:review).permit(
      :work_life_balance,
      :workplace_atmosphere,
      :flex_system,
      :remote_work,
      :harassment_prevention,
      :parental_care_leave,
      :childcare_support,
      :welfare_facilities,
      :mental_health_care,
      :evaluation_system,
      :promotion_salary,
      :overtime_holiday_work,
      :allowances_subsidies,
      :training_education_support,
      :career_support,
      :work_engagement,
      :content,
      :select,
      :user_id,
      :company_id)
  end

  def set_review #今回は人のレビューも見ることができる
    @review = Review.find_by(id: params[:id])
  end

  def business_user?
    unless current_user.company?
      flash[:notice] = "アクセスできません"
      redirect_to users_path
    end
  end

end
