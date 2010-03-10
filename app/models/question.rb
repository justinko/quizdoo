# == Schema Information
#
# Table name: questions
#
#  id            :integer         not null, primary key
#  quiz_id       :integer
#  body          :text
#  answers_count :integer         default(0)
#  position      :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class Question < ActiveRecord::Base
  
  attr_accessible :body
  
  belongs_to :quiz, :counter_cache => true
  
  has_many :answers, :order => 'answers.position ASC',
                     :dependent => :destroy
  
  has_many :user_answers, :dependent => :destroy
  
  validates_presence_of :quiz_id,
                        :body
                        
  validates_uniqueness_of :body, :scope => :quiz_id
                        
  acts_as_list :scope => :quiz_id
  
  acts_as_markdown :body
  
  def has_correct_answer?
    not correct_answer.nil?
  end
  
  def correct_answer
    answers.scoped_by_correct(true).first
  end
    
  def next
    self.class.first :conditions => ['quiz_id = ? AND id > ?', quiz_id, id],
                     :order => 'id ASC'
  end
  
  def prev
    self.class.first :conditions => ['quiz_id = ? AND id < ?', quiz_id, id],
                     :order => 'id DESC'
  end
end
