# == Schema Information
#
# Table name: user_answers
#
#  id          :integer         not null, primary key
#  user_id     :integer
#  question_id :integer
#  answer_id   :integer
#  correct     :boolean
#  created_at  :datetime
#  updated_at  :datetime
#

class UserAnswer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question
  belongs_to :answer
  
  validates_presence_of :user_id,
                        :question_id,
                        :answer_id
                        
  validates_uniqueness_of :user_id, :scope => [:question_id, :answer_id],
                                    :message => 'has already answered this question'
  
  before_create :set_correct                                  
  after_create :update_correct_or_incorrect_count
  
  private
  
  def set_correct
    self.correct = true if question.correct_answer == answer
  end
  
  def update_correct_or_incorrect_count
    if participation = user.find_participation(question.quiz)
      count_field = correct? ? :correct_count : :incorrect_count
      participation.increment!(count_field)
    end
  end
end
