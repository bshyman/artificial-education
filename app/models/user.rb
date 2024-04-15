class User < ApplicationRecord
  validates :first_name, presence: true
  validate :birthday_is_valid_format
  validate :xp_is_not_negative

  def xp_is_not_negative
    return unless xp&.negative?

    errors.add(:base, 'XP cannot be negative')
  end

  # validates_numericality_of :xp,
  #                           only_integer: true,
  #                           greater_than_or_equal_to: 0,
  #                           message: 'Not enough XP to make this purchase!'

  belongs_to :group

  enum role: %i[admin player]

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

  def last_group_member?
    group.users.count == 1
  end

  private

  def birthday_is_valid_format
    return unless birthday.present?

    errors.add(:birthday, 'is not a valid date') unless birthday.is_a?(Date)
  end
end
