# == Schema Information
#
# Table name: answers
#
#  id          :integer         not null, primary key
#  question_id :integer
#  body        :text
#  correct     :boolean
#  position    :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Answer < ActiveRecord::Base
  
  attr_accessible :body,
                  :correct
                  
  belongs_to :question, :counter_cache => true
  
  has_many :user_answers, :dependent => :destroy
  
  validates_presence_of :question_id,
                        :body
                        
  validates_uniqueness_of :body, :scope => :question_id
    
  acts_as_list :scope => :question_id
  
  acts_as_markdown :body
end
