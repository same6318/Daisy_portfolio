class Admin::CompaniesController < ApplicationController

  def index
    @companies = Company
    .select('companies.id, companies.name, COUNT(reviews.id) AS reviews_count')
    .joins(users: :reviews)
    .group('companies.id')
    binding.irb
  end

  def show
    @company = Company.find(params[:id])
    @user = @company.user
    @review_count = @company.users.joins(:reviews).count
  end

  def destroy
    @company.destroy
    redirect_to admin_companies_path
  end

end
