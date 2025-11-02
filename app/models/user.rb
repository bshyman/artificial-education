# frozen_string_literal: true

# user model
class User < ApplicationRecord
  has_secure_password
  validates :first_name, presence: true
  validate :birthday_is_valid_format
  validate :bank_is_not_negative
  validates :email, presence: true, if: :adult?

  def bank_is_not_negative
    errors.add(:base, 'bank cannot be negative') if bank.negative?
  end

  belongs_to :group
  has_many :tasks, foreign_key: 'assigned_user_id', dependent: :destroy
  has_many :created_tasks, class_name: 'Task', foreign_key: 'created_by_id', dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :rounds, dependent: :destroy

  enum role: { adult: 'adult', child: 'child', super: 'super' }

  def adult?
    role == 'adult' || role == 'super'
  end

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

  def icon_for_role
    adult? ? 'user' : 'child'
  end

  private

  def birthday_is_valid_format
    return unless birthday.present?

    errors.add(:birthday, 'is not a valid date') unless birthday.is_a?(Date)
  end
end
