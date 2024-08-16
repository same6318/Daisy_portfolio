class ReviewsController < ApplicationController
  before_action :authenticate_user! #ログインしてなかったらログイン画面に自動的に遷移
  before_action :set_review, only: [:show]
  before_action :review_edit, only: [:edit, :update, :destroy]

  def index
    @company = Company.find_by(id: params[:company_id])
    @q = @company.reviews.ransack(params[:q])
    @company_reviews = @q.result.order(created_at: :desc).page(params[:page]).per(10)
  end


  def new
    @user = current_user
    @company = Company.find_by(id: params[:company_id]) #企業一覧ページから選択した企業IDを取得したい
    @review = @company.reviews.build
    @review_form_attr = Review.form_attr
  end

  def create
    @company = Company.find_by(id: params[:company_id])
    @review = @company.reviews.build(review_params)
    @review_form_attr = Review.form_attr
    if @review.save
      flash[:notice] = t('.created')
      redirect_to company_review_path(@company, @review)
    else
      # flash[:alert] = "レビューの作成に失敗しました"
      render :new, status: :unprocessable_entity #エラーが起こった時のステータスコードが返る
    end
  end

  def show
    @user = @review.user
    @company = @review.company
  end

  def edit
    @company = @review.company
    @review_form_attr = Review.form_attr
  end

  def update
    @company = Company.find_by(id: @review.company)
    @review_form_attr = Review.form_attr
    if @review.update(review_params)
      flash[:notice] = t('.updated')
      redirect_to company_review_path(@company, @review)
    else
      flash[:alert] = "更新に失敗しました"
      render :edit
    end
  end

  def destroy
    @review.destroy
    flash[:notice] = t('.destroyed')
    redirect_to users_path
  end


  private

  def review_params
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
      :enrollment_status).merge(user_id: current_user.id)
  end

  def set_review #今回は人のレビューも見ることができる
    @review = Review.find_by(id: params[:id])
  end

  def review_edit
    @review = Review.find_by(id: params[:id], user_id: current_user.id)
    unless @review
      flash[:alert] = "ページのロードに失敗しました"
      redirect_to users_path
    end
  end

  def business_user?
    unless current_user.company?
      flash[:alert] = "ページのロードに失敗しました"
      redirect_to users_path
    end
  end

end
