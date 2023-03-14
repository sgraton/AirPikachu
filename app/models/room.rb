class Room < ApplicationRecord
  enum instant: {Request: 0, Instant: 1}
  
  belongs_to :user
  has_many :reservations
  has_many :guest_reviews
  has_many :calendars

  validates :home_type, presence: true
  validates :room_type, presence: true
  validates :accommodate, presence: true
  validates :bed_room, presence: true
  validates :bath_room, presence: true

  has_many_attached :images
  geocoded_by :address
  after_validation :geocode, if: :address_changed?


  def self.ransackable_attributes(auth_object = nil)
    ["accommodate", "active", "address", "bath_room", "bed_room", "created_at", "home_type", "id", "instant", "is_air", "is_heating", "is_internet", "is_kitchen", "is_tv", "latitude", "listing_name", "longitude", "price", "room_type", "summary", "updated_at", "user_id"]
  end

  def cover_photo
    if self.images.length > 0
      self.images[0]
    else
      "blank.jpg"
    end
  end

  def average_rating
    guest_reviews.count == 0 ? 0 : guest_reviews.average(:star).round(2).to_i
  end
end
