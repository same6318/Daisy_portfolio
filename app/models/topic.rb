class Topic < ApplicationRecord
  belongs_to :user
  belongs_to :company, optional: true

  validates :title, presence: true
  validates :content, presence: true
  
  def self.ransackable_attributes(auth_object = nil)
    %w[title content user_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user]
  end

end
