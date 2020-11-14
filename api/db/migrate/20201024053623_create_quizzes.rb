class CreateQuizzes < ActiveRecord::Migration[6.0]
  def change
    create_table :quizzes do |t|
      t.references :quiz_set, null: false, foreign_key: true
      t.integer :number, null: false
      t.string :text, null: false, limit: 256
      t.string :image_key
      t.string :answer_image_key

      t.timestamps
    end

    add_index :quizzes, :number
    add_index :quizzes, %i[number quiz_set_id], unique: true
  end
end
