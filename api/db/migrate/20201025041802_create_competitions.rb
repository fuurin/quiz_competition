class CreateCompetitions < ActiveRecord::Migration[6.0]
  def change
    create_table :competitions do |t|
      t.references :quiz_set, null: false, foreign_key: true, index: { unique: true }
      # 将来的に1つのクイズを複数のクイズ集から参照するかもしれないのでquizはuniqueにしない
      t.references :quiz, null: false, foreign_key: true
      t.integer :status, null: false, default: 0
      t.string :rid, null: false

      t.timestamps
    end

    add_index :competitions, :rid, unique: true
  end
end
