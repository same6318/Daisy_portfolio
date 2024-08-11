require 'rails_helper'

RSpec.describe "Topics", type: :system do
  # before do
  #   driven_by(:rack_test)
  # end

  let!(:user5) { FactoryBot.create(:user5) }

  before do
    visit new_user_session_path
    fill_in "user[email]", with: "user@test.com"
    fill_in "user[password]", with: "password123"
    click_button "ログイン"
  end

  describe "登録機能" do
    context "トピックスを登録した場合" do
      it "登録したトピックスが表示される" do
        topic = FactoryBot.create(:topic3, user_id: user5.id)
        if topic.save
          visit topic_path(topic)
          expect(page).to have_text("いくじ")
        else
          visit new_topic_path
        end
      end
    end
  end

  describe "一覧表示機能" do
    let!(:topic) { FactoryBot.create(:topic, title:"最後", created_at: "2023-07-01", user_id:user5.id) }
    let!(:topic3) { FactoryBot.create(:topic3, title:"真ん中", created_at: "2023-08-01", user_id:user5.id) }
    let!(:topic4) { FactoryBot.create(:topic4, title:"最初", created_at: "2023-09-01", user_id:user5.id) }

    context "一覧画面に遷移した場合" do
      it "登録済みのトピックス一覧が表示される" do
        visit topics_path
        expect(page).to have_content("コード")
        expect(page).to have_content("てすとこーど")
        expect(page).to have_content("カイゴ")
      end

      it "作成済みのトピックス一覧が作成日時の降順で表示される" do
        visit topics_path
        cards = all('.card') #何でドットがないと取得できないんだ？
        titles = cards.map do |card|
          card.find('h5').text
        end

        expect(titles).to eq(["最初", "真ん中", "最後"])
      end
    end

    context "新たにトピックスを作成した場合" do
      let!(:topic4) { FactoryBot.create(:topic4, title:"新規に作成したものです", user_id:user5.id) }
      before do
        visit topics_path
      end

      it "新しいトピックスが先頭に表示される" do
        cards = all('.card') #何でドットがないと取得できないんだ？
        titles = cards.map do |card|
          card.find('h5').text
        end

        expect(titles).to eq(["新規に作成したものです", "真ん中", "最後"])
        expect(titles).not_to eq(["最後", "真ん中", "新規に作成したものです"])
      end
    end
  end

  describe "検索機能" do
    let!(:topic) { FactoryBot.create(:topic, user_id:user5.id) }
    let!(:topic3) { FactoryBot.create(:topic3, user_id:user5.id) }
    let!(:topic4) { FactoryBot.create(:topic4, user_id:user5.id) }
    before do
      visit topics_path
    end

    context "タイトルと本文のあいまい検索をした場合" do
      it "検索ワードを含むトピックスのみ表示される" do
        fill_in "q[title_or_content_cont]", with: "である"
        click_on "検索"
        expect(page).to have_content("大変困難")
        expect(page).not_to have_content("作成中")
        input = "大変"
        search = Topic.ransack(title_or_content_cont: input) #ここでransack検索を使って、代入する
        result = search.result #ransackの結果は.resultを実行してから値に代入する必要がある
        expect(result.count).to eq 1
      end
    end

    context "タイトルと本文の検索をカタカナにした場合" do
      it "ひらがなに変換されて検索ワードのトピックスが表示されるか" do
        fill_in "q[title_or_content_cont]", with: "テストコード"
        click_on "検索"
        expect(page).to have_content("確認用")
        expect(page).to have_content("TEST")
        cards = all(".card")
        expect(cards.size).to eq(2)
      end
    end

    context "ジャンルで検索した場合" do
      it "検索したジャンルに一致するトピックスのみ表示される" do
        choose "キャリア" #ラジオボタンの選択はラベルのテキストを渡す
        # binding.irb
        click_on "検索"
        expect(page).to have_content("大変困難")
        expect(page).not_to have_content("確認用")
        cards = all(".card")
        expect(cards.size).to eq(1)
      end
    end

    context "タイトルとジャンルで検索した場合" do
      it "検索ワードandジャンルに一致するタスクのみ表示される" do
        fill_in "q[title_or_content_cont]", with: "ジャンル"
        choose "子育て"
        click_on "検索"
        expect(page).not_to have_content("大変困難")
        expect(page).not_to have_content("てすとこーど")
        cards = all(".card")
        expect(cards.size).to eq(0)
      end
    end

    describe "詳細表示機能" do
      context "任意のトピックス詳細画面に遷移した場合" do
        it "そのトピックスの内容が表示される" do
          topic = FactoryBot.create(:topic, user_id:user5.id)
          visit topic_path(topic)
          expect(page).to have_content("作成中")
        end

        it "そのトピックスの編集ができる" do
          topic = FactoryBot.create(:topic, user_id:user5.id)
          visit topic_path(topic)
          click_on "編集"
          fill_in "topic[title]", with: "UPDATEしました"
          click_on "投稿する"
          expect(page).to have_content("UPDATE")
        end

      end
    end



  end

end
