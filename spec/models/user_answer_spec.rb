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

require 'spec_helper'

describe UserAnswer do
  fixtures :user_answers
  
  should_not_allow_mass_assignment_of :user_id,
                                      :question_id,
                                      :answer_id,
                                      :correct
  
  should_belong_to :user,
                   :question,
                   :answer
                   
  should_validate_presence_of :user_id,
                              :question_id,
                              :answer_id
                              
  should_validate_uniqueness_of :user_id, :scope => [:question_id, :answer_id],
                                          :message => 'has already answered this question'
                                          
  describe '#correct?' do
    it { user_answers(:one).should be_correct }
  end
  
  describe 'updating participant correct counts' do
    fixtures :users, :questions, :answers
    
    before do
      UserAnswer.delete_all
      
      @user_answer = UserAnswer.new 
      @user_answer.user = users(:justin)
      @user_answer.question = questions(:one)
      @user_answer.answer = answers(:one)
    end
    
    it 'should create a new record' do
      lambda {
        @user_answer.save!
      }.should change(UserAnswer, :count).by(1)
    end
    
    it 'should increment correct_count for participation' do
      Participation.any_instance.expects(:increment!).with(:correct_count).once
      @user_answer.save!
    end
    
    it 'should increment incorrect_count for participation' do
      @user_answer.answer = answers(:two)
      Participation.any_instance.expects(:increment!).with(:incorrect_count).once
      @user_answer.save!
    end
  end
end
