# == Schema Information
#
# Table name: questions
#
#  id            :integer         not null, primary key
#  quiz_id       :integer
#  body          :text
#  answers_count :integer         default(0)
#  position      :integer
#  created_at    :datetime
#  updated_at    :datetime
#

require 'spec_helper'

describe Question do
  fixtures :questions
  
  should_belong_to :quiz
  
  should_have_many :answers,
                   :user_answers
  
  should_validate_presence_of :quiz_id,
                              :body
                              
  should_validate_uniqueness_of :body, :scope => :quiz_id
  
  describe '#has_correct_answer?' do
    it { questions(:one).should have_correct_answer }
    
    describe 'with all answers deleted' do
      before { Answer.delete_all }
      it { questions(:one).should_not have_correct_answer }
    end
  end
  
  describe '#correct_answer' do
    it { questions(:one).answers.first == questions(:one).correct_answer }
  end
  
  describe '#next and #prev' do
    fixtures :quizzes
    
    before do
      5.times do |i|
        Question.create :quiz => quizzes(:rails),
                        :body => 'blah' + i.to_s
      end
      
      @question = Question.all.at(3)
    end
    
    it { @question.next.id.should == @question.id + 1 }
    it { @question.prev.id.should == @question.id - 1 }
  end
end
