module ReviewsHelper
  def review_placeholder
    <<-"EOS".strip_heredoc
    会社に対するレビューを自由記入で入力してください。（100文字以上）
    （例1）働きやすさやワークライフバランスに関して
    （例2）休暇の取りやすさや職場環境に関して
    （例3）仕事のやりがいや働きやすい環境であったか等
    EOS
  end
end
