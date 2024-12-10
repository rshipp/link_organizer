class QueuedLink < ApplicationRecord
  belongs_to :user

  validates_presence_of :url

  scope :active, -> { where(deleted_at: nil, applied_at: nil) }
end
