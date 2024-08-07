module ReviewsHelper
  def review_placeholder
    <<-"EOS".strip_heredoc
    100文字以上で
    表示させたい文字
    表示させたい文字  
    EOS
  end
end
