require 'rails_helper'

RSpec.describe "レビュー管理機能", type: :system, js: true do
  describe '登録機能' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:company) { FactoryBot.create(:company) }
    let!(:review) { FactoryBot.create(:review, user: user, company: company) }

    before do
      sign_in user
    end

    context 'レビューを登録した場合' do
      it '登録したレビューが表示される' do
        visit new_company_review_path(company.id)

        # 評価項目のリスト
        ratings = %w[
          work_life_balance_field
          workplace_atmosphere_field
          flex_system_field
          remote_work_field
          harassment_prevention_field
          parental_care_leave_field
          childcare_support_field
          welfare_facilities_field
          mental_health_care_field
          evaluation_system_field
          promotion_salary_field
          overtime_holiday_work_field
          allowances_subsidies_field
          training_education_support_field
          career_support_field
          work_engagement_field
        ]

        # 各評価項目に対して評価をクリック
        ratings.each do |field|
          find("##{field}").find("img[alt='5']").click
        end

        fill_in 'review[content]', with: "a" * 100

        click_button '登録する'

        # 確認する項目のリスト
        confirmation_texts = [
          'ワークライフバランス',
          '職場の雰囲気',
          'フレックス制度',
          'リモートワーク',
          'ハラスメント対策',
          '育児介護休暇',
          '育児支援',
          '福利厚生施設',
          'メンタルヘルスケア',
          '評価制度',
          '昇進・給与に関して',
          '残業・休日出勤',
          '手当・補助等',
          '研修・教育支援',
          'キャリアアップ支援',
          '仕事のやりがい'
        ]

        # 各確認項目がページに表示されていることを検証
        confirmation_texts.each do |text|
          expect(page).to have_content text
        end
      end
    end

    context '新たにレビューを作成した場合' do
      it 'レビュー詳細ページに遷移する' do
        new_review = FactoryBot.create(:review, user: user)

        visit company_review_path(review.company_id, review)

        expect(page).to have_content '在籍状況'
        expect(page).to have_content '年代'
        expect(page).to have_content '性別'
        expect(page).to have_content '点数'
        expect(page).to have_content '項目'
      end
    end
  end
  
  describe 'レビュ一覧表示機能', type: :system do
    let!(:user) { FactoryBot.create(:user) }
    let!(:company) { FactoryBot.create(:company) }
    let!(:review) { FactoryBot.create(:review, user: user, company: company) }
  
    before do
      sign_in user
    end
  
    context 'レビュー一覧に遷移した場合' do
      it '企業名が表示される' do
        visit companies_path
  
        expect(page).to have_content '企業名'
        expect(page).to have_content '住所'
        expect(page).to have_content '総合評価'
      end
    end
  end

  describe 'ソート機能' do
    let!(:user) { create(:user) }
    let!(:female) {create(:user, :female, age: "thirties")}
    let!(:male) { FactoryBot.create(:user, :male, age: "forties") }
    let!(:company) { FactoryBot.create(:company) }
    let!(:first_review) { FactoryBot.create(:first_review, user: user, company: company) }
    let!(:second_review) { FactoryBot.create(:second_review, user: female, company: company) }
    let!(:third_review) { FactoryBot.create(:third_review, user: male, company: company) }

    before do
      sign_in female
      visit company_reviews_path(company)
    end
  
    it '登録済みのレビュー覧が在籍状態の降順で表示される' do
      
      click_on '在籍状態'
      sleep 0.1
      review_contents = all('.table tbody tr').map do |select|
        select.all('td')[4].text.strip
      end
      #binding.irb
      #puts review_contents.inspect 
      #review_contents = all('.table tbody tr').map(&:td[1].text)
      #puts page.body # 現在のページのHTMLを表示

      expect(review_contents).to eq ['退社済み','現職', '現職',]
    end

    it '登録済みのレビュー覧が性別の降順で表示される' do

      click_on '性別'
      sleep 0.1

      review_contents = all('.table tbody tr').map do |gender|
        gender.all('td')[3].text.strip
      end

      #binding.irb
      puts review_contents.inspect

      expect(review_contents).to eq ['男性','女性', '女性',]
    end

    it '登録済みのレビュー覧が年代の昇順で表示される' do

      click_on '年代'
      sleep 0.1
      review_contents = all('.table tbody tr').map do |age|
        
        age.all('td')[2].text.strip
      end

      expect(review_contents).to eq ['20代','30代','40代']
    end
  end

  describe '検索機能' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:company) { FactoryBot.create(:company) }
    let!(:review) { FactoryBot.create(:review, user: user, company: company) }
    
    before do
      sign_in user
      visit companies_path
    end

    context '企業名であいまい検索をした場合' do
      it "検索ワードを含む企業名のみ表示される" do
        
        fill_in 'q[name_cont]', with: 'テ'
        click_on '検索'
        expect(page).to have_content 'テスト会社'
      end
    end
    context '住所検索した場合' do
      it "検索した住所に一致する企業のみ表示される" do
        
        fill_in 'q[address_cont]', with: '住'
        click_on '検索'
        expect(page).to have_content 'テスト住所'
      end
    end
  end
end
