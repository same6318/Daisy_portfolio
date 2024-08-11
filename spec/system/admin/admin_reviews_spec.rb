require 'rails_helper'

RSpec.describe "Admin::Reviews", type: :system do

  let!(:admin) { FactoryBot.create(:admin) }
  let!(:user5) { FactoryBot.create(:user5) }
  let!(:company5) { FactoryBot.create(:company5) }

  before do
    visit new_admin_session_path
    fill_in "user[email]", with: "user3@test.com"
    fill_in "user[password]", with: "123456"
    click_button "登録する"
  end

  describe "一覧表示機能" do
    let!(:review5) { FactoryBot.create(:review5, user_id:user5.id, company_id:company5.id) }
    let!(:review6) { FactoryBot.create(:review6, user_id:user5.id, company_id:company5.id) }
    let!(:review7) { FactoryBot.create(:review7, user_id:user5.id, company_id:company5.id) }

    context "一覧画面に遷移した場合" do
      it "登録済みのレビュー一覧が表示される" do
        visit admin_reviews_path
        expect(page).to have_content("福利厚生")
        expect(page).to have_content("職場環境")
        expect(page).to have_content("有給休暇取得率")
      end
    end

    context "新たにレビューを作成した場合" do
      it "新しいレビューが一番上に表示される" do
        user2 = FactoryBot.create(:user7)
        company = FactoryBot.create(:company5)
        review = FactoryBot.create(:review5, enrollment_status: true, user_id:user2.id, company_id:company.id)
        visit admin_reviews_path
        rows = all("tbody tr")
        reviews_select = rows.map do |row|
          row.all("td")[5].text
        end
        expect(reviews_select).to eq(["現職","現職","退社済み","現職"])
        reviews = all("tbody tr")
        expect(reviews.size).to eq(4)
      end
    end
  end

  describe "ソート機能" do
    let!(:review5) { FactoryBot.create(:review5, created_at: "2023/07/01", user_id:user5.id, company_id:company5.id) }
    let!(:review6) { FactoryBot.create(:review6, created_at: "2023/08/01",user_id:user5.id, company_id:company5.id) }
    let!(:review7) { FactoryBot.create(:review7, created_at: "2023/09/01",user_id:user5.id, company_id:company5.id) }
    before do
      visit admin_reviews_path
    end

    context "「企業名」のソートボタンをクリックした場合" do
      it "昇順に並び替えられたレビュー一覧が表示される" do
        company2 = FactoryBot.create(:company5, name: "サンプルコーポレーション")
        review = FactoryBot.create(:review5, user_id:user5.id, company_id:company2.id)
        click_on "企業名"
        reviews = all("tbody tr")
        company_names = reviews.map do |review|
          review.all("td")[2].text
        end
        expect(company_names).to eq(["サンプルコーポレーション", "株式会社テストカンパニー", "株式会社テストカンパニー", "株式会社テストカンパニー"])
      end
    end

    context "「年代」のソートボタンをクリックした場合" do
      it "昇順に並び替えられたレビュー一覧が表示される" do
        user2 = FactoryBot.create(:user7)
        review = FactoryBot.create(:review5, user_id:user2.id, company_id:company5.id)
        click_on "年代"
        reviews = all("tbody tr")
        user_ages = reviews.map do |review|
          review.all("td")[3].text
        end
        expect(user_ages).to eq(["10代", "20代", "20代", "20代"])
      end
    end

    context "「性別」のソートボタンをクリックした場合" do
      it "昇順に並び替えられたレビュー一覧が表示される" do
        user2 = FactoryBot.create(:user7)
        review = FactoryBot.create(:review5, user_id:user2.id, company_id:company5.id)
        click_on "性別"
        reviews = all("tbody tr")
        user_genders = reviews.map do |review|
          review.all("td")[4].text
        end
        expect(user_genders).to eq(["男性", "男性", "男性", "女性"])
      end
    end

    context "「在籍状態」のソートボタンをクリックした場合" do
      it "昇順に並び替えられたレビュー一覧が表示される" do
        click_on "在籍状態"
        reviews = all("tbody tr")
        user_select = reviews.map do |review|
          review.all("td")[5].text
        end
        expect(user_select).to eq(["退社済み", "現職", "現職"])
      end
    end

    context "「作成日時」のソートボタンをクリックした場合" do
      it "昇順に並び替えられたレビュー一覧が表示される" do
        click_on "作成日時"
        reviews = all("tbody tr")
        user_select = reviews.map do |review|
          review.all("td")[8].text
        end
        expect(user_select).to eq(["2023/07/01", "2023/08/01", "2023/09/01"])
      end
    end
  end

  describe "検索機能" do
    let!(:review5) { FactoryBot.create(:review5, user_id:user5.id, company_id:company5.id) }
    let!(:review6) { FactoryBot.create(:review6, user_id:user5.id, company_id:company5.id) }
    let!(:review7) { FactoryBot.create(:review7, user_id:user5.id, company_id:company5.id) }
    before do
      visit admin_reviews_path
    end

    context "企業名検索をした場合" do
      it "検索ワードを含む企業名のレビューのみ表示される" do
        company2 = FactoryBot.create(:company5, name: "サンプルコーポレーション")
        review = FactoryBot.create(:review5, user_id:user5.id, company_id:company2.id)
        fill_in "q[company_name_cont]", with: "コーポレーション"
        click_on "検索"
        expect(page).to have_content("サンプルコーポレーション")
        expect(page).to have_content("3.7")
      end
    end

    context "投稿者名(user.name)検索をした場合" do
      it "検索ワードを含むレビューのみ表示される" do
        user2 = FactoryBot.create(:user7, name: "検索用で見つける人")
        review = FactoryBot.create(:review5, user_id:user2.id, company_id:company5.id)
        fill_in "q[user_name_cont]", with: "検索用"
        click_on "検索"
        reviews = all("tbody tr")
        user_names = reviews.map do |review|
          review.all("td")[6].text
        end
        expect(user_names).to eq(["検索用で見つける人"])
      end
    end

    context "本文検索をした場合" do
      it "検索ワードを含むレビューのみ表示される" do
        fill_in "q[content_cont]", with: "福利厚生"
        click_on "検索"
        reviews = all("tbody tr")
        expect(reviews.size).to eq(1)
      end
    end

  end

  describe "詳細表示機能" do
    context "任意のレビュー詳細画面に遷移した場合" do
      it "そのレビューの内容が表示される" do
        review = FactoryBot.create(:review6, user_id:user5.id, company_id:company5.id)
        visit admin_review_path(review)
        expect(page).to have_content("職場環境")
        expect(page).not_to have_content("保険制度")
      end

      it "登録済みのレビューの平均が計算して表示される" do
        review = FactoryBot.create(:review6, user_id:user5.id, company_id:company5.id)
        visit admin_review_path(review)
        expect(page).to have_content("2.7")
      end

      it "そのレビューの削除ができる" do
        review = FactoryBot.create(:review6, user_id:user5.id, company_id:company5.id)
        visit admin_review_path(review)
        click_on "削除"
        expect(page).not_to have_content("株式会社サンプル3") #削除後は一覧に戻っているので、表示されてない。
      end
    end
  end


end
