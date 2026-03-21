class Pool < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  has_many :pool_memberships, dependent: :destroy
  has_many :members, through: :pool_memberships, source: :user
  has_many :markets

  validates :name, presence: true
  validates :pool_type, inclusion: { in: %w[public private] }

  before_create :generate_invite_code, if: -> { pool_type == 'private' }

  scope :public_pools, -> { where(pool_type: 'public') }
  scope :private_pools, -> { where(pool_type: 'private') }

  def member?(user)
    members.include?(user)
  end

  private

  def generate_invite_code
    self.invite_code = SecureRandom.alphanumeric(8).upcase
  end
end
