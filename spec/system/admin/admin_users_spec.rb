require 'rails_helper'

RSpec.describe "Admin::Users", type: :system do
  # before do
  #   driven_by(:rack_test)
  # end

  let!(:admin) { FactoryBot.create(:admin) }

  before do
    visit new_admin_session_path
    fill_in "user[email]", with: "user3@test.com"
    fill_in "user[password]", with: "123456"
    click_button "登録する"
  end

  describe "一覧表示機能" do
    let!(:user5) { FactoryBot.create(:user5) }
    let!(:user6) { FactoryBot.create(:user6) }

    context "一覧画面に遷移した場合" do
      it "登録済みのユーザー一覧が表示される" do
        visit admin_users_path
        expect(page).to have_content("いっぱん")
        expect(page).to have_content("きぎょう")
      end
    end

    context "新たにユーザーを作成した場合" do
      let!(:user7) { FactoryBot.create(:user7) }
      before do
        visit admin_users_path
      end

      it "新しいユーザーが一番上に表示される" do
        rows = all("tbody tr") #行を取得してから
        user_names = rows.map do |row| #その行の中にあるtdの２個目を取得する
          row.all("td")[1].text
        end
        expect(user_names).to eq(["一般ゆーざー","きぎょうユーザー","いっぱんユーザー", "管理者"])
      end
    end
  end

  describe "ソート機能" do
    let!(:user5) { FactoryBot.create(:user5) }
    let!(:user6) { FactoryBot.create(:user6) }
    let!(:user7) { FactoryBot.create(:user7) }
    before do
      visit admin_users_path
    end

    context "「メールアドレス」のソートボタンをクリックした場合" do
      it "昇順に並び替えられたユーザー一覧が表示される" do
        click_on "メールアドレス"
        rows = all("tbody tr")
        user_emails = rows.map do |row|
          row.all("td")[3].text
        end
        expect(user_emails).to eq(["user2@test.com", "user3@test.com", "user4@test.com", "user@test.com"])
        #数字が先に昇順対象になる。
      end
    end
  end

  describe "検索機能" do
    let!(:user5) { FactoryBot.create(:user5) }
    let!(:user6) { FactoryBot.create(:user6) }
    let!(:user7) { FactoryBot.create(:user7) }
    before do
      visit admin_users_path
    end

    context "名前とハンドルネームであいまい検索をした場合" do
      it "検索ワードを含むユーザーのみ表示される" do
        fill_in "q[name_or_screen_name_cont]", with: "ユーザー"
        click_on "検索"
        expect(page).to have_content("一般")
        expect(page).to have_content("きぎょう")
        users = all("tbody tr")
        expect(users.size).to eq(3)
        fill_in "q[name_or_screen_name_cont]", with: "ネーム"
        click_on "検索"
        users = all("tbody tr")
        expect(users.size).to eq(2)
      end
    end

    context "メールアドレス検索をした場合" do
      it "検索ワードを含むユーザーのみ表示される" do
        fill_in "q[email_cont]", with: "2"
        click_on "検索"
        rows = all("tbody tr")
        user_names = rows.map do |row|
          row.all("td")[1].text
        end
        expect(user_names).to eq(["きぎょうユーザー"])

      end
    end

    context "権限検索をした場合" do
      it "検索したユーザーのみ表示される" do
        fill_in "q[role_eq]", with: "2"
        click_on "検索"
        rows = all("tbody tr")
        user_names = rows.map do |row|
          row.all("td")[1].text
        end
        expect(user_names).to eq(["管理者"])
        fill_in "q[role_eq]", with: "0"
        click_on "検索"
        users = all("tbody tr")
        expect(users.size).to eq(2)
      end
    end

  end

  describe "詳細表示機能" do
    context "任意のユーザー詳細画面に遷移した場合" do
      it "そのユーザーの内容が表示される" do
        user = FactoryBot.create(:user5)
        visit admin_user_path(user)
        expect(page).to have_content("トピックス投稿数")
        expect(page).to have_content("ユーザー削除")
      end
    end
  end





end
