class ReviewsController < ApplicationController
  #before_action :business_user?, only: [:new, :create, :edit, :update, :destroy]
  before_action :authenticate_user! #ログインしてなかったらログイン画面に自動的に遷移
  before_action :set_review, only: [:show, :edit, :update, :destroy]

  def index
    #@q = Review.ransack(params[:q])
    @company = Company.find_by(id: params[:company_id]) #企業一覧ページから選択した企業IDを取得したい
    @q = @company.reviews.ransack(params[:q])
    #binding.irb

    sorted_reviews = @q.result
                    #  .where(company_id: @company.id)

    # binding.irb
                     #.sort_by(&:review_average).reverse #これはページリロードと同時に評価点数上位がソートされる
    # if params[:sort_by].present?
    #   sorted_reviews = sorted_reviews.joins(:user)
    #                                  .order("users.#{params[:sort_by]} ASC")
    # end

    # @company_reviews = sorted_reviews.page(params[:page]).per(10)
    @company_reviews = Kaminari.paginate_array(sorted_reviews).page(params[:page]).per(5)
    # @company_reviews.map {|d| {average:d.review_average, **d.attributes}}.sort_by {|a| a[:average]}
    #binding.irb
  end


  def new
    @user = current_user
    @company = Company.find_by(id: params[:company_id]) #企業一覧ページから選択した企業IDを取得したい
    @review = @company.reviews.build
  end

  def create
    @company = Company.find_by(id: params[:company_id]) #企業一覧ページから選択した企業IDを取得したい
    @review = @company.reviews.build(review_params)
    if @review.save
      flash[:notice] = t('.created')
      redirect_to company_review_path(@company, @review)
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
    @company = Company.find_by(id: @review.company) #企業一覧ページから選択した企業IDを取得したい
    if @review.update(review_params)
      flash[:notice] = t('.updated')
      redirect_to company_review_path(@company, @review)
    else
      flash[:notice] = "更新に失敗しました"
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
      :select).merge(user_id: current_user.id)
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
