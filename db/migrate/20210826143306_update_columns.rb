# frozen_string_literal: true

class UpdateColumns < ActiveRecord::Migration[6.1]
  def change
    change_column_null :tasks, :slug, false
    change_column_null :tasks, :created_at, false
    change_column_null :tasks, :updated_at, false
  end
end
