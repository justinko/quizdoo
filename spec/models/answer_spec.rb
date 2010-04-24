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

require 'spec_helper'

describe Answer do  
  should_not_allow_mass_assignment_of :question_id
  
  should_belong_to :question
  
  should_have_many :user_answers
  
  should_validate_presence_of :question_id,
                              :body
                              
  should_validate_uniqueness_of :body, :scope => :question_id
end
