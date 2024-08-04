require 'rails_helper'

RSpec.describe "Admin::Topics", type: :system do

  let!(:admin) { FactoryBot.create(:admin) }

  before do
    visit new_admin_session_path
    fill_in "user[email]", with: "user3@test.com"
    fill_in "user[password]", with: "123456"
    click_button "登録する"
  end

  describe "一覧表示機能" do

    let!(:user) { FactoryBot.create(:user) }
    let!(:topic) { FactoryBot.create(:topic, user_id: user.id) }
    let!(:topic3) { FactoryBot.create(:topic3, user_id: user.id) }

    context "一覧画面に遷移した場合" do
      it "登録済みのトピック一覧が表示される" do
        visit admin_topics_path
        expect(page).to have_content("TEST")
        expect(page).to have_content("育児・介護")
      end
    end

    context "新たにトピックを作成した場合" do
      let!(:topic4) { FactoryBot.create(:topic4, title: "アドミン用で作成しました", user_id: user.id) }
      before do
        visit admin_topics_path
      end

      it "新しいトピックが一番上に表示される" do
        topics = all("tbody tr")
        topic_titles = topics.map do |topic|
          topic.all("td")[1].text
        end
        expect(topic_titles).to eq(["アドミン用で作成しました", "ジャンルは育児・介護", "TEST"])
      end
    end

  end

  describe "ソート機能" do
    let!(:user) { FactoryBot.create(:user) }
    let!(:topic) { FactoryBot.create(:topic, title:"最後", created_at: "2023/07/01", user_id:user.id) }
    let!(:topic3) { FactoryBot.create(:topic3, title:"真ん中", created_at: "2023/08/01", user_id:user.id) }
    let!(:topic4) { FactoryBot.create(:topic4, title:"最初", created_at: "2023/09/01", user_id:user.id) }

    context "「作成日時」のソートボタンをクリックした場合" do
      it "昇順に並び替えられたトピック一覧が表示される" do
        visit admin_topics_path
        click_on "作成日時"
        topics = all("tbody tr")
        topic_dates = topics.map do |topic|
          topic.all("td")[5].text
        end
        expect(topic_dates).to eq(["2023/07/01", "2023/08/01", "2023/09/01"])
      end
    end

  end

  describe "検索機能" do
    let!(:user) { FactoryBot.create(:user) }
    let!(:topic) { FactoryBot.create(:topic, user_id:user.id) }
    let!(:topic3) { FactoryBot.create(:topic3, user_id:user.id) }
    let!(:topic4) { FactoryBot.create(:topic4, user_id:user.id) }
    before do
      visit admin_topics_path
    end

    context "タイトルと本文の検索をカタカナにした場合" do
      it "ひらがなに変換されて検索ワードのトピックスが表示されるか" do
        fill_in "q[title_or_content_cont]", with: "テストコード"
        click_on "検索"
        expect(page).to have_content("確認用")
        expect(page).to have_content("TEST")
        topics = all("tbody tr")
        expect(topics.size).to eq(2)
      end
    end

    context "ハンドルネームで検索した場合" do
      it "検索ワードを含むトピックのみ表示される" do
        user2 = FactoryBot.create(:user3)
        topic = FactoryBot.create(:topic, title: "HNありで作成しました", user_id: user2.id)
        visit admin_topics_path
        fill_in "q[user_screen_name_cont]", with: "はんどる"
        click_on "検索"
        expect(page).to have_content("HN")
        topics = all("tbody tr")
        expect(topics.size).to eq(1)
      end
    end

    context "投稿者名(user.name)で検索した場合" do
      it "検索ワードを含むトピックのみ表示される" do
        user2 = FactoryBot.create(:user3, name: "2人目のユーザーです")
        topic = FactoryBot.create(:topic, user_id: user2.id)
        visit admin_topics_path
        fill_in "q[user_name_cont]", with: "2人目"
        click_on "検索"
        expect(page).to have_content("TEST")
      end
    end
  end

  describe "詳細表示機能" do
    let!(:user) { FactoryBot.create(:user) }

    context "任意のトピックス詳細画面に遷移した場合" do
      it "そのトピックスの内容が表示される" do
        topic = FactoryBot.create(:topic, user_id:user.id)
        visit admin_topic_path(topic)
        expect(page).to have_content("作成中")
      end

      it "そのトピックスの削除ができる" do
        topic = FactoryBot.create(:topic, user_id:user.id)
        visit admin_topic_path(topic)
        click_on "削除"
        expect(page).not_to have_content("作成中") #削除後は一覧に戻っているので、表示されてない。
      end

    end
  end


end
