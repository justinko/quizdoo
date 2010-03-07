# == Schema Information
#
# Table name: quiz_participants
#
#  id              :integer         not null, primary key
#  user_id         :integer
#  quiz_id         :integer
#  correct_count   :integer         default(0)
#  incorrect_count :integer         default(0)
#  created_at      :datetime
#  updated_at      :datetime
#

class QuizParticipant < ActiveRecord::Base
  belongs_to :user
  belongs_to :quiz
  
  validates_presence_of :user_id,
                        :quiz_id
                        
  validates_uniqueness_of :quiz_id, :scope => :user_id,
                                    :message => 'is already on your participation list'
end
