class AddQuizPermalink < ActiveRecord::Migration
  def self.up
    add_column :quizzes, :permalink, :string
    add_index :quizzes, :permalink
    
    Quiz.all.each(&:save)
  end

  def self.down
    remove_index :quizzes, :permalink
    remove_column :quizzes, :permalink
  end
end
