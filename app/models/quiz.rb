# == Schema Information
#
# Table name: quizzes
#
#  id          :integer         not null, primary key
#  category_id :integer
#  title       :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

class Quiz < ActiveRecord::Base
  belongs_to :category, :counter_cache => true
  belongs_to :user
  
  has_many :questions, :order => 'questions.position ASC',
                       :dependent => :destroy
  
  validates_presence_of :title, :user_id
  
  validates_uniqueness_of :title, :case_sensitive => false
  
  named_scope :recently_added, :limit => 10,
                               :order => 'created_at DESC'
end
