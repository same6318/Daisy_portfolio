FactoryBot.define do
  factory :company do
    name { "株式会社テストカンパニー" }
    capital { 1000000 }
    employee { 100 }
    sales { 10000000 }
    description { "テスト用に作成した企業です" }
    address { "大阪府大阪市北区梅田2-2-2" }
    industry { 1 }
    company_url { "http://www.testcompany.com" }
    contact { "contact@testcompany.com" }
  end
end
