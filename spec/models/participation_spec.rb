# == Schema Information
#
# Table name: participations
#
#  id              :integer         not null, primary key
#  user_id         :integer
#  quiz_id         :integer
#  correct_count   :integer         default(0)
#  incorrect_count :integer         default(0)
#  created_at      :datetime
#  updated_at      :datetime
#

require 'spec_helper'

describe Participation do
  fixtures :participations
  
  should_belong_to :user, :quiz
  
  should_validate_presence_of :user_id,
                              :quiz_id
                              
  should_validate_uniqueness_of :quiz_id, :scope => :user_id,
                                          :message => 'is already on your participation list'
end
