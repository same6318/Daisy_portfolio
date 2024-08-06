FactoryBot.define do
  factory :topic do
    title { "TEST" }
    content { "テストコード作成中" }
    genre { 2 }
    author_name { "true" }
    association :user

    after(:build) do |topic|
      topic.topic_image.attach(io: File.open("spec/fixtures/files/test.jpg"), filename: "test.jpg")
    end
  end

  factory :topic2, class: Topic do
    title { "画像じゃないものを添付する" }
    content { "てすとこーど作成中" }
    author_name { "true" }
    association :user

    after(:build) do |topic|
      topic.topic_image.attach(io: File.open("spec/fixtures/files/test.txt"), filename: "test.txt")
    end
  end

  factory :topic3, class: Topic do
    title { "ジャンルは育児・介護" }
    content { "いくじとカイゴ、それぞれの両立は大変困難である" }
    genre { 0 }
    author_name { "false" }
    association :user

  end

  factory :topic4, class: Topic do
    title { "検索ワードの確認用" }
    content { "てすとこーど作成中" }
    genre { 1 }
    author_name { "true" }
    association :user
  end


end
