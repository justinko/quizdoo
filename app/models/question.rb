# == Schema Information
#
# Table name: questions
#
#  id            :integer         not null, primary key
#  quiz_id       :integer
#  body          :text
#  answers_count :integer         default(0)
#  created_at    :datetime
#  updated_at    :datetime
#

class Question < ActiveRecord::Base
  belongs_to :quiz, :counter_cache => true
  
  has_many :answers, :dependent => :destroy
  
  validates_presence_of :quiz,
                        :body
                        
  acts_as_list :scope => :quiz
  
  acts_as_markdown :body
end
