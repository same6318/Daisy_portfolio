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

  factory :user5, class: User do
    email { "user@test.com" }
    role { 0 }
    name { "いっぱんユーザー" }
    age { 1 }
    gender { 0 }
    screen_name { "ハンドルネーム" }
    password { "password123" }
    password_confirmation { "password123" }
    provider { "email" }
    uid { "user@test.com" }
  end

  factory :user6, class: User do
    email { "user2@test.com" }
    role { 1 }
    name { "きぎょうユーザー" }
    age { 2 }
    gender { 1 }
    screen_name { "" }
    password { "password123" }
    password_confirmation { "password123" }
    provider { "email" }
    uid { "user2@test.com" }
  end

  factory :user7, class: User do
    email { "user4@test.com" }
    role { 0 }
    name { "一般ゆーざー" }
    age { 0 }
    gender { 1 }
    screen_name { "はんどるネーム" }
    password { "password123" }
    password_confirmation { "password123" }
    provider { "email" }
    uid { "user4@test.com" }
  end

  factory :admin, class: User do
    email { "user3@test.com" }
    role { 2 }
    name { "管理者" }
    age { 3 }
    gender { 1 }
    screen_name { "" }
    password { "123456" }
    password_confirmation { "123456" }
    provider { "email" }
    uid { "user3@test.com" }
  end

end
