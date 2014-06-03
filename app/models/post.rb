class Post < ActiveRecord::Base
  validates :title, :submitter_id, :sub_id, presence: true
  
  belongs_to :submitter, class_name: "User", foreign_key: :submitter_id, primary_key: :id
  belongs_to :sub
end
