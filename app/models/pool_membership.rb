class PoolMembership < ApplicationRecord
  belongs_to :user
  belongs_to :pool

  validates :user_id, uniqueness: { scope: :pool_id }
end
