class Quiz < ApplicationRecord
  belongs_to :quiz_set
  has_many :options, dependent: :destroy

  validates :number, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :text, presence: true, length: { maximum: 256 }

  # mount_uploader :image, ImageUploader
  # mount_uploader :answer_image, ImageUploader

  default_scope { order(:number) }
end
