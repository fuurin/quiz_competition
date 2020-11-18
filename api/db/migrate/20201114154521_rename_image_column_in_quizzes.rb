class RenameImageColumnInQuizzes < ActiveRecord::Migration[6.0]
  def change
    rename_column :quizzes, :image, :image_key
    rename_column :quizzes, :answer_image, :answer_image_key
  end
end
