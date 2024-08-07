require 'rails_helper'

RSpec.describe Topic, type: :model do
  describe "バリデーションのテスト" do
    context "トピックのタイトルが空文字の場合" do
      it "バリデーションに失敗する" do
        topic = Topic.create(title: "", content: "Content")
        expect(topic).not_to be_valid
      end
    end

    context "トピックの本文が空文字の場合" do
      it "バリデーションに失敗する" do
        topic = Topic.create(title: "Test", content: "")
        expect(topic).not_to be_valid
      end
    end

    context "トピックにimageファイル以外を添付する場合" do
      it "バリデーションに失敗する" do
        user = FactoryBot.create(:user)
        topic = FactoryBot.build(:topic2, user_id:user.id)
        expect(topic).not_to be_valid
      end
    end

    context "トピックにimageファイルを添付する場合" do
      it "トピックを登録できる" do
        user = FactoryBot.create(:user)
        topic = FactoryBot.create(:topic, user_id:user.id)
        expect(topic).to be_valid
      end
    end

    context "タイトルと本文に値が入っている場合" do
      it "トピックを登録できる" do
        user = FactoryBot.create(:user)
        topic = FactoryBot.create(:topic, user_id:user.id)
        expect(topic).to be_valid
      end
    end

  end


end
