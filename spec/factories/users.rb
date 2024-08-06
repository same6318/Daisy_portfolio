FactoryBot.define do
  factory :user do
    name { "一般ユーザ" }
    email { "user@example.com" }
    password { "123456" }
    password_confirmation { "123456" }
    screen_name { "あああ" }
    age { "twenties" } # ここで年齢を指定
    gender { "female" } # 性別を指定
    role { "general" } # ユーザステータスを指定

    trait :female do
      email { 'female@gmail.com'}
      uid { 'female@gmail.com' }
      gender { 'female' }
    end
  
    trait :male do
      email { 'male@gmail.com'}
      uid { 'male@gmail.com' }
      gender { 'male' }
    end
  end
end
