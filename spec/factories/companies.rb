FactoryBot.define do
  factory :company5, class: Company do
    name { "株式会社テストカンパニー" }
    capital { 1000000 }
    employee { 100 }
    sales { 10000000 }
    description { "当社は、地熱発電向けの次世代バッテリーを開発し、最新技術の研究に取り組んでいます。\n
                  持続可能なエネルギー供給を目指し、革新的なソリューションで地球に優しい未来を創造します。" }
    address { "大阪府大阪市北区梅田2-2-2" }
    industry { 1 }
    company_url { "http://www.testcompany.com" }
    contact { "contact@testcompany.com" }
  end

  factory :company6, class: Company do
    name { "株式会社造船メーカー" }
    capital { 2000000 }
    employee { 150 }
    sales { 20000000 }
    description { "当社は、小型船舶の製造に特化し、個人オーナー向けに最新技術を駆使した船を提供しています。\n
                  長年の経験と技術力を活かし、安心・安全な船作りを通じてお客様の満足度を高めることを目指しています。" }
    address { "神奈川県横浜市西区みなとみらい3-3-3" }
    industry { 0 }
    company_url { "http://www.shipmanufacturer.com" }
    contact { "contact@shipmanufacturer.com" }
  end

  factory :company8, class: Company do
    name { "株式会社IOTソリューションズ" }
    capital { 3000000 }
    employee { 200 }
    sales { 30000000 }
    description { "当社は、IOT技術の普及を目指し、日々新しいソリューションを提供しています。\n
                  あらゆる分野においてIOT技術を活用し、効率的で革新的なサービスを開発し、社会の進歩に貢献します。" }
    address { "東京都千代田区大手町1-1-1" }
    industry { 2 }
    company_url { "http://www.iot-solutions.com" }
    contact { "contact@iot-solutions.com" }
  end

  factory :company7, class: Company do
    name { "株式会社テスト会社" }
    capital { 1000000 }
    employee { 100 }
    sales { 10000000 }
    description { "a" * 100 }
    address { "大阪府大阪市北区梅田2-2-2" }
    industry { 1 }
    company_url { "http://www.testcompany.com" }
    contact { "contact@testcompany.com" }


    after(:build) do |company|
      company.company_image.attach(io: File.open("spec/fixtures/files/test.jpg"), filename: "test.jpg")
    end
  end
end
  


