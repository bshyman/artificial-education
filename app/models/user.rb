class User < ApplicationRecord
  validates :first_name, presence: true
  validate :birthday_is_valid_format
  def level
    xp / 100 + 1
  end

  def level_progress
    xp % 100
  end

  def name
    [first_name, last_name].compact.join(' ')
  end

  def age
    return 'N/A' unless birthday

    today = Date.today
    age = today.year - birthday.year
    age -= 1 if today < birthday + age.years
    age
  end

  def birthday_is_valid_format
    return unless birthday.present?

    errors.add(:birthday, 'is not a valid date') unless birthday.is_a?(Date)
  end
end
