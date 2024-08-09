class CompaniesController < ApplicationController
  before_action :authenticate_user! #ログインしてなかったらログイン画面に自動的に遷移
  before_action :company_edit, only:[:edit, :update, :destroy]

  def index
    @q = Company.ransack(params[:q])
    @companies = @q.result.left_joins(:reviews) #企業テーブルにレビューテーブルを結合
                        .select('companies.*, COUNT(reviews.id) AS reviews_count') #レビューidの数をカウントする
                        .group('companies.id') #集計する為にグループ化する
                        .order(created_at: :desc)
                        .page(params[:page]).per(10)
  end

  def show
    @company = Company.find(params[:id])
    @reviews = @company.reviews
    @pickup_reviews = @company.reviews.order(created_at: :desc).limit(3) #新着レビュー3個ピックアップ
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.create(company_params)
    if @company.save
      current_user.update_without_password(company_id: @company.id)
      flash[:notice] = t('.created')
      redirect_to company_path(@company)
    else
      render :new
    end
  end

  def edit
    @company = Company.find(params[:id])
    @user = current_user
  end

  def update
    @company = Company.find(params[:id])
    if @company.update(company_params)
      flash[:notice] = t('.updated')
      redirect_to company_path(@company)
    else
      flash[:alert] = "更新に失敗しました"
      render :edit
    end
  end

  def destroy
    @company.destroy
    redirect_to users_path
  end

  private

  def company_params
    params.require(:company).permit(:name, :capital, :employee, :sales, :description,
                                    :address, :industry, :company_url, :contact,
                                    :company_image)
  end

  def company_edit #edit、update、destoryで他人が入れないようにする
    @company = Company.find_by(id: params[:id])
    unless @company.id == current_user.company_id
      flash[:alert] = "ページのロードに失敗しました"
      redirect_to users_path
    end
  end

end