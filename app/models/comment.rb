class Comment < ActiveRecord::Base
  validates :content, :submitter_id, :post_id, presence: true
  
  belongs_to :submitter, class_name: "User", foreign_key: :submitter_id, primary_key: :id
  
  belongs_to :post
end
