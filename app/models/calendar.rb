class Calendar < ApplicationRecord
  belongs_to :room
  
  enum status: [:Available, :Not_Available]
  validates :day, presence: true
end
