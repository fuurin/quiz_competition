class CreateQuizSets < ActiveRecord::Migration[6.0]
  def change
    create_table :quiz_sets do |t|
      t.references :admin, null: false, foreign_key: true
      t.string :name, null: false, limit: 128

      t.timestamps
    end
  end
end
