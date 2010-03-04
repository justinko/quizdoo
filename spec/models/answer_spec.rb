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

require 'spec_helper'

describe Answer do
  fixtures :answers
  
  should_belong_to :question
  
  should_validate_presence_of :question,
                              :body
                              
  should_validate_uniqueness_of :body, :scope => :question_id
end
