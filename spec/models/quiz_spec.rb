# == Schema Information
#
# Table name: quizzes
#
#  id              :integer         not null, primary key
#  category_id     :integer
#  user_id         :integer
#  title           :string(255)
#  description     :text
#  questions_count :integer         default(0)
#  created_at      :datetime
#  updated_at      :datetime
#

require 'spec_helper'

describe Quiz do
  fixtures :quizzes
  
  should_belong_to :category,
                   :user
  
  should_have_many :questions
  
  should_validate_presence_of :title
  
  should_validate_uniqueness_of :title
  
  should_have_scope :recently_added, :limit => 10,
                                     :order => 'created_at DESC'
end
