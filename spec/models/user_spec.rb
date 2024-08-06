require 'rails_helper'

RSpec.describe 'ユーザモデル機能', type: :model do
  describe 'バリデーションのテスト' do
    let(:user){FactoryBot.build(:user)}

    context 'ユーザのメールアドレスが空文字の場合' do
      it 'バリデーションに失敗する' do
        user.email = ''
        user.valid?
        expect(user.errors[:email]).to include('を入力してください')
      end
    end

    context 'ユーザのパスワードが空文字の場合' do
      it 'バリデーションに失敗する' do
        user.password = ''
        user.password_confirmation = ''
        user.valid?
        expect(user.errors[:password]).to include('を入力してください')
      end
    end

    context 'ユーザのパスワード(確認)が空文字の場合' do
      it 'バリデーションに失敗する' do
        user.password_confirmation = ''
        user.valid?
        expect(user.errors[:password_confirmation]).to include('とパスワードの入力が一致しません')
      end
    end

    context 'ユーザのメールアドレスがすでに使用されていた場合' do
      it 'バリデーションに失敗する' do
        FactoryBot.create(:user, email: 'user@example.com' )
        user.email = 'user@example.com'
        user.valid?
        expect(user.errors[:email]).to include('はすでに存在します')
      end
    end

    context 'ユーザのパスワードが6文字未満の場合' do
      it 'バリデーションに失敗する' do
        user.password = '12345'
        user.valid? 
        expect(user.errors[:password]).to include('は6文字以上で入力してください')
      end
    end

    context 'メールアドレスが使われていない値で、かつパスワードが6文字以上の場合' do
      it 'バリデーションに成功する' do
        user.name = '一般ユーザ'
        user.email = 'user15@xxx.com'
        user.password = '123456'
        user.password_confirmation = '123456'
        user.valid?
        expect(user).to be_valid
      end
    end
  end
end
