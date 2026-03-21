class Report < ApplicationRecord
  belongs_to :market
  belongs_to :reporter, class_name: 'User'

  validates :reason, presence: true
  validates :status, inclusion: { in: %w[pending reviewed] }
end
