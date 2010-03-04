# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

User.create :name => 'Justin Ko',
            :email => 'test@test.com',
            :password => 'test',
            :password_confirmation => 'test'
            
            
['Programming', 'Science', 'Politics', 'Finance', 'People'].each do |name|
  Category.create :name => name
end

Quiz.create :title => 'Ruby on Rails',
            :category => Category.find_by_name('Programming'),
            :user => User.first

quiz = Quiz.find_by_title('Ruby on Rails')

question = quiz.questions.create :body => 'What is a polymorphic relationship?'
