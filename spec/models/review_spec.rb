require 'rails_helper'

RSpec.describe Review, type: :model do
  describe 'バリデーションのテスト' do
    let(:user){FactoryBot.build(:user)}
    let(:review) { FactoryBot.build(:review, user: user) }

    context 'レビューが全て未入力の場合' do
      it 'バリデーションに失敗する' do
        attributes = [
          :work_life_balance, :workplace_atmosphere, :flex_system, :remote_work,
          :harassment_prevention, :parental_care_leave, :childcare_support,
          :welfare_facilities, :mental_health_care, :evaluation_system,
          :promotion_salary, :overtime_holiday_work, :allowances_subsidies,
          :training_education_support, :career_support, :work_engagement, :content
        ]

        attributes.each do |attr|
          review.send("#{attr}=", '')
        end

        expect(review).to be_invalid
        attributes.each do |attr|
          expect(review.errors[attr]).to include('を入力してください')
        end
      end
    end

    context 'レビューが1つでも未入力の場合' do
      it 'バリデーションに失敗する' do
        review.work_life_balance = ''

        expect(review).to be_invalid
        expect(review.errors[:work_life_balance]).to include('を入力してください')
      end
    end
    
    context '本文が100文字以下の場合' do
      it 'バリデーションに失敗する' do
        review.content = 'コンテント'
        expect(review).to be_invalid
        expect(review.errors[:content]).to include('は100文字以上で入力してください')
      end
    end

    context '在籍状態' do
      context 'trueの場合' do
        it '有効' do
          review.enrollment_status = true
          expect(review.valid?).to be_truthy
        end
      end
      context 'falseの場合' do
        it '有効' do
          review.enrollment_status = false
          expect(review.valid?).to be_truthy
        end
      end
      context 'nilの場合' do
        it '有効でfalseになる' do
          review.enrollment_status = nil
          expect(review.valid?).to be_falsey
        end
      end
    end
  end
end
