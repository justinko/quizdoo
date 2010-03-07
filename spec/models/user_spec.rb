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
                   :participations,
                   :participating_quizzes,
                   :answers
  
  should_validate_presence_of :name
  
  should_validate_uniqueness_of :name
  
  describe 'participation' do
    before do
      QuizParticipant.delete_all
      
      @user = users(:justin)
      @quiz = quizzes(:rails)
    end
    
    it 'should create a new quiz participation record' do
      lambda {
        @user.participate!(@quiz)
      }.should change(QuizParticipant, :count).by(1)
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
        }.should change(QuizParticipant, :count).by(-1)
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
  
  describe '#answered_count' do
    it { users(:justin).answered_count(quizzes(:rails), :correct).should eql(1) }
    it { users(:justin).answered_count(quizzes(:rails), :incorrect).should eql(0) }
  end
end
