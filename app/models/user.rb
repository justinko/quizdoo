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

class User < ActiveRecord::Base
  acts_as_authentic do |config|
    config.crypto_provider = Authlogic::CryptoProviders::BCrypt
  end
  
  has_many :quizzes, :dependent => :destroy
  
  validates_presence_of :name
  
  validates_uniqueness_of :name, :case_sensitive => false
end
