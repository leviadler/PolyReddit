class Post < ActiveRecord::Base
  validates :title, :submitter_id, :sub_id, presence: true

  belongs_to :submitter, class_name: "User", foreign_key: :submitter_id, primary_key: :id
  belongs_to :sub

  has_many :comments

  has_many :top_level_comments,
            -> { where "parent_comment_id IS NULL" },
            class_name: "Comment",
            foreign_key: :post_id


  has_many :votes, as: :votable

  def sum_votes
    self.votes.sum(:value)
  end
end
