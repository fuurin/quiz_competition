class CreateAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :answers do |t|
      t.references :user, null: false, foreign_key: true
      t.references :competition, null: false, foreign_key: true
      t.references :quiz, null: false, foreign_key: true
      t.references :option, null: false, foreign_key: true

      t.timestamps
    end

    add_index :answers, %i[user_id competition_id quiz_id], name: "one_answer_for_one_quiz_uk", unique: true
  end
end
