class AddCaucusToTerms < ActiveRecord::Migration[5.0]
  def change
      add_column :terms, :caucus, :string
  end
end
