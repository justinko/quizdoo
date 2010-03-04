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

require 'spec_helper'

describe Question do
  should_belong_to :quiz
  
  should_have_many :answers
  
  should_validate_presence_of :quiz,
                              :body
end
