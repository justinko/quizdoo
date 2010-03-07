# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

me = User.create :name => 'Justin Ko',
                 :email => 'test@test.com',
                 :password => 'test',
                 :password_confirmation => 'test'

dhh = User.create :name => 'David Hanson',
                  :email => 'dhh@test.com',
                  :password => 'test',
                  :password_confirmation => 'test'            
            
['Programming', 'Science', 'Politics', 'Finance', 'People'].each do |name|
  Category.create :name => name
end

Quiz.create :title => 'Ruby on Rails',
            :category => Category.find_by_name('Programming'),
            :user => me
            
Quiz.create :title => 'Checking and Savings',
            :category => Category.find_by_name('Finance'),
            :user => dhh

quiz1 = Quiz.find_by_title('Ruby on Rails')

quiz1.questions.create :body => 'What is a polymorphic relationship?'

quiz2 = Quiz.find_by_title('Checking and Savings')

question1 = quiz2.questions.create :body => 'Should you ever pay over draft fees?'

question1.answers.create :body => 'Yes'

question1.answers.create :body => 'No'