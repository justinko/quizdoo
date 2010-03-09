# == Schema Information
#
# Table name: users
#
#  id                  :integer         not null, primary key
#  name                :string(255)
#  email               :string(255)     not null
#  crypted_password    :string(255)     not null
#  password_salt       :string(255)     not null
#  persistence_token   :string(255)     not null
#  single_access_token :string(255)     not null
#  perishable_token    :string(255)     not null
#  login_count         :integer         default(0), not null
#  failed_login_count  :integer         default(0), not null
#  last_request_at     :datetime
#  current_login_at    :datetime
#  last_login_at       :datetime
#  current_login_ip    :string(255)
#  last_login_ip       :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#

require 'spec_helper'

describe User do
  fixtures :users, :quizzes
  
  should_have_many :quizzes,
                   :questions,
                   :participations,
                   :participating_quizzes,
                   :answers
  
  should_validate_presence_of :name
  
  should_validate_uniqueness_of :name
  
  describe 'participation' do
    before do
      Participation.delete_all
      
      @user = users(:justin)
      @quiz = quizzes(:rails)
    end
    
    it 'should create a new quiz participation record' do
      lambda {
        @user.participate!(@quiz)
      }.should change(Participation, :count).by(1)
    end
    
    it { @user.participating?(@quiz).should be_false }
    
    describe 'with created participation record' do
      before do
        @user.participate!(@quiz)
      end
      
      it { @user.participating?(@quiz).should be_true }
      
      it 'should delete the record' do
        lambda {
          @user.unparticipate!(@quiz)
        }.should change(Participation, :count).by(-1)
      end
      
      it 'should delete all user answers for the participation quiz' do
        lambda {
          @user.unparticipate!(@quiz)
        }.should change(UserAnswer, :count).by(-1)
      end
    end
  end
  
  describe '#answer_question!' do
    fixtures :questions, :answers
    
    before do
      UserAnswer.delete_all
      @user = users(:justin)
      @question = questions(:one)
      @answer = answers(:one)
      @params = { :user_answer => { :answer_id => @answer.id }}
    end
    
    it 'should create a UserAnswer record' do
      lambda { create_user_answer }.should change(UserAnswer, :count).by(1)
    end
    
    describe 'with created UserAnswer record' do
      before do
        create_user_answer
        @user_answer = UserAnswer.first
      end
      
      it { @user_answer.question.should eql(@question) }
      it { @user_answer.answer.should eql(@answer) }
    end
    
    def create_user_answer
      @user.answer_question!(@question, @params)
    end
  end
  
  describe '#all_answered?' do
    before do
      @user = users(:justin)
      @quiz = quizzes(:rails)
    end
    
    it { @user.all_answered?(@quiz).should be_true }
    
    describe 'with second question created' do
      before do
        @quiz.questions.create :body => 'testing'
      end
      
      it { @user.all_answered?(@quiz).should be_false }
    end
  end
  
  describe '#total_answered' do
    it { users(:justin).total_answered(quizzes(:rails)).should eql(1) }
  end
  
  describe '#can_edit_answer?' do
    fixtures :answers
    
    before { @answer = answers(:one) }
    
    it { users(:justin).can_edit_answer?(@answer).should be_true }
    
    describe 'with answer that has no question' do
      before do
        @answer.update_attribute(:question_id, nil)
      end
      
      it { users(:justin).can_edit_answer?(@answer).should be_false }
    end
  end
  
  describe '#can_edit_question?' do
    fixtures :questions
    
    before { @question = questions(:one) }
    
    it { users(:justin).can_edit_question?(@question).should be_true }
    
    describe 'with question that has no quiz' do
      before do
        @question.update_attribute(:quiz_id, nil)
      end
      
      it { users(:justin).can_edit_quiz?(@question).should be_false }
    end
  end
  
  describe '#can_edit_quiz?' do
    before { @quiz = quizzes(:rails) }
    
    it { users(:justin).can_edit_quiz?(@quiz).should be_true }
    
    describe 'with quiz that has no user' do
      before do
        @quiz.update_attribute(:user_id, nil)
      end
      
      it { users(:justin).can_edit_quiz?(@quiz).should be_false }
    end
  end
  
  describe '#deliver_password_reset_instructions!' do
    it 'should send an email to the user' do
      user = users(:justin)
      Emailer.expects(:deliver_password_reset_instructions).with(user).once
      user.deliver_password_reset_instructions!
    end
  end
  
  describe '#find_participation' do
    fixtures :participations
    
    it 'should find the correct participation record' do
      participation = participations(:one)
      quiz = quizzes(:rails)
      users(:justin).find_participation(quiz).should eql(participation)
    end
  end
end
