require 'rails_helper'

RSpec.describe "Admin::Companies", type: :system do

  let!(:admin) { FactoryBot.create(:admin) }

  before do
    visit new_admin_session_path
    fill_in "user[email]", with: "user3@test.com"
    fill_in "user[password]", with: "123456"
    click_button "登録する"
  end

  describe "一覧表示機能" do
    let!(:company5) { FactoryBot.create(:company5) }
    let!(:company6) { FactoryBot.create(:company6) }
    let!(:company7) { FactoryBot.create(:company7) }

    context "一覧画面に遷移した場合" do
      it "登録済みの企業一覧が表示される" do
        visit admin_companies_path
        expect(page).to have_content("テストカンパニー")
        expect(page).to have_content("造船メーカー")
        expect(page).to have_content("株式会社IOT")
      end
    end

    context "新たに企業を作成した場合" do
      let!(:company7) { FactoryBot.create(:company7, name:"株式会社新規作成") }
      before do
        visit admin_companies_path
      end

      it "新しい企業が一番上に表示される" do
        companies = all("tbody tr")
        company_names = companies.map do |name|
          name.all("td")[1].text
        end
        expect(company_names).to eq (["株式会社新規作成", "株式会社造船メーカー", "株式会社テストカンパニー"])
      end
    end

  end

  describe "ソート機能" do
    let!(:company5) { FactoryBot.create(:company5, created_at: "2023/07/01") }
    let!(:company6) { FactoryBot.create(:company6, created_at: "2023/08/01") }
    let!(:company7) { FactoryBot.create(:company7, created_at: "2023/09/01") }
    before do
      visit admin_companies_path
    end

    context "登録日時のソートボタンをクリックした場合" do
      it "昇順に並び替えられた企業一覧が表示される" do
        click_on "登録日時"
        companies = all("tbody tr")
        company_dates = companies.map do |date|
          date.all("td")[6].text
        end
        expect(company_dates).to eq (["2023/07/01", "2023/08/01", "2023/09/01"])
      end
    end

    context "企業名のソートボタンをクリックした場合" do
      it "昇順に並び替えられた企業一覧が表示される" do
        click_on "企業名"
        companies = all("tbody tr")
        company_names = companies.map do |name|
          name.all("td")[1].text
        end
        expect(company_names).to eq (["株式会社IOTソリューションズ", "株式会社テストカンパニー", "株式会社造船メーカー"])
      end
    end

  end

  describe "検索機能" do
    let!(:company5) { FactoryBot.create(:company5, name: "検索会社") }
    let!(:company6) { FactoryBot.create(:company6, address: "京都府京都市中京区烏丸通御池上る二条殿町542") }
    let!(:company7) { FactoryBot.create(:company7) }
    before do
      visit admin_companies_path
    end

    context "企業名で検索した場合" do
      it "検索ワードの企業が表示されるか" do
        fill_in "q[name_cont]", with: "検索"
        click_on "検索"
        expect(page).to have_content("検索会社")
        expect(page).to have_content("大阪府大阪市")
        companies = all("tbody tr")
        expect(companies.size).to eq(1)
      end
    end

    context "住所で検索した場合" do
      it "検索ワードの企業が表示されるか" do
        fill_in "q[address_cont]", with: "京都市"
        click_on "検索"
        expect(page).to have_content("株式会社造船メーカー")
        expect(page).not_to have_content("大阪府大阪市")
        companies = all("tbody tr")
        expect(companies.size).to eq(1)
      end
    end

    context "業界・業種で検索した場合" do
      it "該当の企業が表示されるか" do
        choose "製造業"
        click_on "検索"
        expect(page).to have_content("株式会社造船メーカー")
        expect(page).not_to have_content("東京都")
        companies = all("tbody tr")
        expect(companies.size).to eq(1)
      end
    end

    context "企業名と住所とジャンルで検索した場合" do
      it "検索ワードandジャンルに一致する企業のみ表示される" do
        fill_in "q[address_cont]", with: "千代田区"
        fill_in "q[name_cont]", with: "株式会社"
        choose "情報通信業"
        click_on "検索"
        expect(page).to have_content("株式会社IOTソリューションズ")
        expect(page).not_to have_content("京都市")
        companies = all("tbody tr")
        expect(companies.size).to eq(1)
      end
    end
  end

  describe "詳細表示機能" do
    context "任意の企業の詳細画面に遷移した場合" do
      it "その企業の内容が表示される" do
        company = FactoryBot.create(:company5)
        visit admin_company_path(company)
        expect(page).to have_content("企業ユーザー名")
      end
    
      it "その企業を削除できる" do
        company = FactoryBot.create(:company5)
        visit admin_company_path(company)
        click_on "削除"
        visit admin_companies_path
        expect(page).not_to have_content("大阪府大阪市")
      end
    end
  end

end
