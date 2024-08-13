require 'rails_helper'

RSpec.describe Company, type: :model do
  describe 'バリデーションのテスト' do
    company = Company.create(name: "", capital: "",employee:'',sales:'',address:'',industry:'',description:'')

    context '企業フォームページの必須項目が空文字の場合' do
      it 'バリデーションに失敗する' do
        company.name = ''
        company.capital = ''
        company.employee = ''
        company.sales = ''
        company.address = ''
        company.industry = ''
        company.description = ''
        expect(company).not_to be_valid
      end
    end

    context "企業フォームページにimageファイルを添付する場合" do
      it "企業ロゴを登録できる" do
        company = FactoryBot.create(:company)
        expect(company).to be_valid
      end
    end

    context "トピックにimageファイル以外を添付する場合" do
      it "バリデーションに失敗する" do
        company.company_image.attach(io: File.open("spec/fixtures/files/test.txt"), filename: "test.txt")
        
        expect(company).not_to be_valid
        expect(company.errors[:company_image]).to include("のファイル形式が不正です。")
      end 
    end
  end
end
