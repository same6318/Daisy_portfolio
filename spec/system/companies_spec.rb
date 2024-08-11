require 'rails_helper'

RSpec.describe "companies", type: :system do
  describe "登録機能" do
    let!(:user1) { create(:user1) }
    let!(:company7) { create(:company7) }

    before do
      visit new_user_session_path
      fill_in "user[email]", with: user1.email
      fill_in "user[password]", with: user1.password
      click_button "ログイン"
      visit new_company_path
    end

    context "企業情報を登録した場合" do
      it "登録した企業情報が表示される" do
        #binding.irb
        company = FactoryBot.create(:company7)  
        visit company_path(company)
        expect(page).to have_text("株式会社テスト会社")
      end
    end
  end
end

