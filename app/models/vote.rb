class Vote < ActiveRecord::Base
  validates :votable_id, :votable_type, :user_id, presence: true
  validates :value, inclusion: { in: [1, -1, 0] }

  belongs_to :votable, polymorphic: true

  belongs_to :user
end
