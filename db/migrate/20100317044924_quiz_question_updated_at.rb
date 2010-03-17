class QuizQuestionUpdatedAt < ActiveRecord::Migration
  def self.up
    add_column :quizzes, :questions_updated_at, :datetime
    add_index :quizzes, :questions_updated_at
    
    add_column :quizzes, :last_viewed, :datetime
    add_index :quizzes, :last_viewed
  end

  def self.down
    remove_index :quizzes, :questions_updated_at
    remove_column :quizzes, :questions_updated_at
    
    remove_index :quizzes, :last_viewed
    remove_column :quizzes, :last_viewed
  end
end
