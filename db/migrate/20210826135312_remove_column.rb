# frozen_string_literal: true

class RemoveColumn < ActiveRecord::Migration[6.1]
  def change
    remove_column :tasks, :body
  end
end
