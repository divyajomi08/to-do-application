# frozen_string_literal: true

class DeleteColumns < ActiveRecord::Migration[6.1]
  def change
    change_column_null :tasks, :slug, true
    change_column_null :tasks, :created_at, true
    change_column_null :tasks, :updated_at, true
  end
end
