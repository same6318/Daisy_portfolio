RSpec.describe "companies", type: :system do


  before do
    sign_in 
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