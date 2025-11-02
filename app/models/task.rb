# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :assigned_user, class_name: 'User', foreign_key: 'assigned_user_id'
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'

  validates :title, presence: true
  validates :points, numericality: { greater_than_or_equal_to: 0 }
  validates :status, inclusion: { in: %w[pending in_progress completed] }
  validates :repeat_frequency, inclusion: { in: %w[daily weekly monthly], allow_nil: true }

  scope :pending, -> { where(status: 'pending') }
  scope :completed, -> { where(status: 'completed') }
  scope :for_user, ->(user_id) { where(assigned_user_id: user_id) }
  scope :created_by_user, ->(user_id) { where(created_by_id: user_id) }
  scope :due_soon, -> { where('due_date <= ?', 1.day.from_now).where(status: 'pending') }

  def complete!
    return false if completed?

    update!(
      status: 'completed',
      completed_at: Time.current
    )

    # Award points to the user
    assigned_user.update!(
      xp: assigned_user.xp + points,
      bank: assigned_user.bank + points
    )

    # Create a new instance if this is a repeating task
    create_next_instance if repeating?

    true
  end

  def completed?
    status == 'completed'
  end

  def overdue?
    due_date.present? && due_date < Time.current && !completed?
  end

  def emoji_for_category
    case title.downcase
    when /clean|chore|room|dish/
      '🧹'
    when /homework|study|read|school/
      '📚'
    when /practice|music|instrument/
      '🎵'
    when /exercise|sport|run/
      '⚽'
    else
      '⭐'
    end
  end

  private

  def create_next_instance
    next_due_date = calculate_next_due_date
    return unless next_due_date

    Task.create!(
      title:,
      description:,
      points:,
      assigned_user_id:,
      created_by_id:,
      repeating: true,
      repeat_frequency:,
      due_date: next_due_date,
      status: 'pending'
    )
  end

  def calculate_next_due_date
    return nil unless due_date && repeat_frequency

    case repeat_frequency
    when 'daily'
      due_date + 1.day
    when 'weekly'
      due_date + 1.week
    when 'monthly'
      due_date + 1.month
    end
  end
end
