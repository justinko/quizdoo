class ActiveRecord::Base
  def error_sentence
    errors.full_messages.to_sentence
  end
end