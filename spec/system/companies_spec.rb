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

  describe '検索機能' do
    let!(:user1) { create(:user1) }
    let!(:company7) { create(:company7) }

    before do
      visit new_user_session_path
      fill_in "user[email]", with: user1.email
      fill_in "user[password]", with: user1.password
      click_button "ログイン"
      visit companies_path
    end

    context '企業名であいまい検索をした場合' do
      it "検索ワードを含む企業名のみ表示される" do
        
        fill_in 'q[name_cont]', with: '株'
        click_on '検索'
        # binding.irb
        # puts page.body
        expect(page).to have_content '株式会社テスト会社'
      end
    end
    context '住所検索した場合' do
      it "検索した住所に一致する企業のみ表示される" do
        
        fill_in 'q[address_cont]', with: '大阪'
        click_on '検索'
        expect(page).to have_content '大阪府大阪市北区梅田2-2-2'
      end
    end
  end
end

