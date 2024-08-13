require 'rails_helper'

RSpec.describe 'ユーザ管理機能', type: :system do
  context 'googleで未サインアップの場合' do
    before do
      Rails.application.env_config["devise.mapping"] = Devise.mappings[:user] # Deviseを使っている人はこれもやる
      # Facebookのモックをomniauth.authに設定
      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
    end

    it 'ユーザーが増えること' do
      visit new_user_registration_path
      #binding.irb
      check 'agreement-checkbox'
      expect(page).to have_button('Googleで登録', wait: 1) # リンクが存在することを確認
      expect {
        click_button 'Googleで登録'
        sleep 1
      }.to change(User, :count).by(1)
    end
  end

  context 'googleでサインアップ済みの場合' do
    provider = :google_oauth2
    resource_name = :user

    before do
      visit new_user_registration_path
      #binding.irb
      check 'agreement-checkbox'
      expect {
        click_button 'Googleで登録'
        sleep 1
      }.to change(User, :count).by(1)
      click_link 'ログアウト'
    end
    

    it 'ユーザーは増えないこと' do
      visit new_user_session_path
      expect {
        click_button 'Googleでログイン'
        sleep 1
      }.to_not change(User, :count)
      expect(page).to have_content 'マイページ'
      expect(page).to have_content 'ログインしました'
    end
  end


  describe 'deviseログイン管理機能' do
    context 'ユーザを登録した場合' do
      it 'マイページに遷移する' do
        visit new_user_registration_path
        fill_in 'user[email]', with: 'user@example.com'
        fill_in 'user[password]', with: '123456'
        fill_in 'user[password_confirmation]', with: '123456'
        fill_in 'user[name]', with: '個人'
        fill_in 'user[screen_name]', with: 'あああ'
        select '20代', from: 'user[age]'
        select '女性', from: 'user[gender]'
        select '個人', from: 'user[role]'
        check 'agreement-checkbox'
        
        click_button '登録する'

        expect(page).to have_content '登録が完了しました'
      end
    end
    
    context 'ログインせずにマイページに遷移した場合' do
      it 'ログイン画面に遷移し、「ログインしてください」というメッセージが表示される' do
        visit users_path
        expect(page).to have_content 'ログインしてください'
      end
    end
  

      # describe 'deviseログイン機能' do
      #   let!(:user) { FactoryBot.create(:user) }

    context '登録済み個人ユーザでログインした場合' do
      let!(:user) { FactoryBot.create(:user) }

      before do
        visit new_user_session_path
        fill_in "user[email]", with: user.email
        fill_in "user[password]", with: user.password
        click_button "ログイン"
      end

      it 'マイページに遷移し「ログインしました」というメッセージが表示される' do
        expect(page).to have_content 'ログインしました'
        expect(page).to have_content 'マイページ'
        expect(page).to have_content 'レビューを投稿する'

      end

      it '自分の詳細画面にアクセスできる' do
        visit user_path(user.id)
        expect(page).to have_content 'アカウント'
        expect(page).to have_content '登録メールアドレス（ID）'
      end

      it '他人のマイページにアクセスすると、自分のマイページに遷移する' do
        other_user = FactoryBot.create(:user, email: 'other_user@example.com', uid: SecureRandom.hex(10), provider: 'email')  
        visit user_path(other_user.id) 
        expect(page).to have_content 'マイページ'
        expect(page).to have_content 'アクセス権限がありません'
      end

      it 'アカウント編集画面から、編集できる' do
        visit edit_user_path(user.id)
        
        fill_in 'user[name]', with: 'user100'
        fill_in 'user[email]', with: 'user100@xxx.com'
        fill_in 'user[password]', with: '123456'
        fill_in 'user[password_confirmation]', with: '123456'
        click_button '更新する'

        expect(page).to have_content 'アカウントを更新しました'
      end
    

      it 'ログアウトするとログイン画面に遷移し、「ログアウトしました」というメッセージが表示される' do
        click_link 'ログアウト'
        expect(page).to have_content 'ログアウトしました'
      end
    end
  end
  
  describe '法人ユーザ管理機能' do
    let(:user) { create(:user1) } # 法人ユーザを作成
    context '法人ユーザでログインした場合' do

      before do
        visit new_user_session_path
        fill_in "user[email]", with: user.email
        fill_in "user[password]", with: user.password
        click_button "ログイン"
        visit users_path
      end

      it 'マイページに企業情報登録ボタンが表示される' do
        #binding.irb
        #puts page.html 
        expect(page).to have_content '企業情報を登録'
      end
      
      it '一度、企業情報を登録すると、登録できない' do
        visit new_company_path
        fill_in "company[name]", with: "株式会社テスト会社"
        fill_in "company[capital]", with: 1000000
        fill_in "company[employee]", with: 100
        fill_in "company[sales]", with: 10000000
        fill_in "company[description]", with: "a" * 100
        fill_in "company[address]", with: "大阪府大阪市北区梅田2-2-2"
        select "サービス業", from: 'company[industry]'
        click_button "登録" 
        visit users_path
        # 企業情報が既に登録されていることを前提としたテスト
        expect(page).not_to have_content '企業情報を登録'
      end
    end
  end
end

