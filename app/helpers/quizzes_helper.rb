module QuizzesHelper
  def quiz_link
    str = ""
    str << 'Quiz: '
    str << link_to(@quiz.title, quiz_path(@quiz))
    
    content_tag(:div, str, :class => 'quiz_link')
  end
end
