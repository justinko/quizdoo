# == Schema Information
#
# Table name: answers
#
#  id          :integer         not null, primary key
#  question_id :integer
#  body        :text
#  correct     :boolean
#  created_at  :datetime
#  updated_at  :datetime
#

class Answer < ActiveRecord::Base
  belongs_to :question, :counter_cache => true
  
  validates_presence_of :question,
                        :body
                        
  validates_uniqueness_of :body, :scope => :question_id
  
  acts_as_markdown :body
end
