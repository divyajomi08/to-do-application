# frozen_string_literal: true

class EditPasswordDigest < ActiveRecord::Migration[6.1]
  def change
    change_column_null :users, :password_digest, false
  end
end
