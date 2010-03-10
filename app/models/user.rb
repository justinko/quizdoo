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
#  username            :string(255)
#

class User < ActiveRecord::Base
  
  acts_as_authentic do |config|
    config.crypto_provider = Authlogic::CryptoProviders::BCrypt
    config.perishable_token_valid_for = 1.hour
  end
    
  has_many :quizzes, :dependent => :destroy
  
  has_many :questions, :through => :quizzes
    
  has_many :participations, :dependent => :destroy
  
  has_many :participating_quizzes, :through => :participations,
                                   :source => :quiz
  
  has_many :answers, :class_name => 'UserAnswer',
                     :dependent => :destroy
  
  validates_presence_of :name,
                        :username
  
  validates_uniqueness_of :name, 
                          :username, :case_sensitive => false
  
  validates_format_of :username, :with => /\A\w+\z/i,
                                 :message => 'only letters, numbers, and underscores please'
                                 
  validates_exclusion_of :username, :in => BLACKLIST_USERNAMES,
                                    :message => 'is not allowed'
  
  def self.find_by_username_or_email(login)
    find_by_username(login) || find_by_email(login)
  end
  
  def participate!(quiz)
    participation = participations.build
    participation.quiz = quiz
    participation.save!
  end
  
  def unparticipate!(quiz)
    find_participation(quiz).destroy
    UserAnswer.destroy_all :user_id => id,
                           :question_id => quiz.question_ids
  end
  
  def participating?(quiz)
    participations.exists?(:quiz_id => quiz)
  end
  
  def answer_question!(question, params)
    answer_id = params[:user_answer][:answer_id]
    answer = question.answers.find(answer_id)
    answers.find_or_create_by_question_id_and_answer_id(question.id, answer.id)
  end
  
  def all_answered?(quiz)
    total_answered(quiz) == quiz.questions.count
  end
  
  def total_answered(quiz)
    answers.count(:conditions => { :question_id => quiz.question_ids })
  end
  
  def can_edit_answer?(answer)
    question_ids.include?(answer.question_id)
  end
  
  def can_edit_question?(question)
    questions.include?(question)
  end
  
  def can_edit_quiz?(quiz)
    quiz.user_id == id
  end
  
  def deliver_password_reset_instructions!
    reset_perishable_token!
    Emailer.deliver_password_reset_instructions(self)
  end
    
  def find_participation(quiz)
    participations.find_by_quiz_id(quiz)
  end
end
