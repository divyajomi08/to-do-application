# frozen_string_literal: true

class Task < ApplicationRecord
  after_create :log_task_details
  RESTRICTED_ATTRIBUTES = %i[title user_id]
  validates :title, presence: true, length: { maximum: 50 }
  validates :slug, uniqueness: true
  validate :slug_not_changed
  belongs_to :user
  enum progress: { pending: 0, completed: 1 }
  enum status: { unstarred: 0, starred: 1 }
  has_many :comments, dependent: :destroy

  before_create :set_slug

  private

    def set_slug
      itr = 1
      loop do
        title_slug = title.parameterize
        slug_candidate = itr > 1 ? "#{title_slug}-#{itr}" : title_slug
        break self.slug = slug_candidate unless Task.exists?(slug: slug_candidate)

        itr += 1
      end
    end

    def slug_not_changed
      if slug_changed? && self.persisted?
        errors.add(:slug, t("task.slug.immutable"))
      end
    end
    def self.of_status(progress)
      if progress == :pending
        starred = pending.starred.order("updated_at DESC")
        unstarred = pending.unstarred.order("updated_at DESC")
      else
        starred = completed.starred.order("updated_at DESC")
        unstarred = completed.unstarred.order("updated_at DESC")
      end
      starred + unstarred
    end
    def log_task_details
      TaskLoggerJob.perform_later(self)
    end
end
