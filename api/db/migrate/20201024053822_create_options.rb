class CreateOptions < ActiveRecord::Migration[6.0]
  def change
    create_table :options do |t|
      t.references :quiz, null: false, foreign_key: true
      t.integer :number, null: false
      t.string :text, null: false, limit: 128
      t.boolean :is_correct_answer, null: false, default: false

      t.timestamps
    end

    add_index :options, :number
    add_index :options, %i[number quiz_id], unique: true
  end
end
