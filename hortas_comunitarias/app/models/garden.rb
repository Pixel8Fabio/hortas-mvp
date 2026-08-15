class Garden < ApplicationRecord
  belongs_to :user
  has_many_attached :photos

  enum :garden_type, { community: 0, school: 1, family: 2 }
  enum :status, { draft: 0, pending_review: 1, approved: 2, rejected: 3, inactive: 4 }

  validates :name, :description, :street, :district, :city, :state, presence: true
  validates :contact_email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validate :acceptable_photos

  scope :publicly_visible, -> { approved.order(:name) }

  geocoded_by :full_address
  after_validation :geocode_and_store_coordinates, if: :address_changed?

  def full_address
    [street, number, district, city, state, postal_code].compact_blank.join(", ")
  end

  def latitude
    coordinates&.y
  end

  def longitude
    coordinates&.x
  end

  def submit_for_review!
    update!(status: :pending_review)
  end

  private

  def geocode_and_store_coordinates
    result = Geocoder.search(full_address).first
    return unless result

    self.coordinates = "POINT(#{result.longitude} #{result.latitude})"
  end

  def address_changed?
    will_save_change_to_street? || will_save_change_to_number? ||
      will_save_change_to_district? || will_save_change_to_city? ||
      will_save_change_to_state? || will_save_change_to_postal_code?
  end

  def acceptable_photos
    photos.each do |photo|
      errors.add(:photos, "deve ser uma imagem") unless photo.content_type&.start_with?("image/")
      errors.add(:photos, "deve ter no máximo 8 MB") if photo.byte_size > 8.megabytes
    end
  end
end
