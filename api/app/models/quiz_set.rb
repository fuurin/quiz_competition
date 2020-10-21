class QuizSet < ApplicationRecord
  belongs_to :admin

  validates :name, presence: true, length: { maximum: 128 }

  scope :by_admin, ->(admin) { where(admin: admin) }
end
