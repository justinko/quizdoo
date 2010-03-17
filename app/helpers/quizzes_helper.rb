module QuizzesHelper
  def quiz_link(bottom = false)
    css_class = 'meta'
    css_class << ' bottom' if bottom || @tags && @tags.empty?
    
    str = ""
    str << 'Quiz: '
    str << link_to(@quiz.title, quiz_path(@quiz))
    
    content_tag(:div, str, :class => css_class)
  end
  
  def meta_question_tags
    return if linked_tags.empty?
    content_tag(:div, 'Tags: ' + linked_tags, :class => 'meta bottom')
  end
  
  def linked_tags(tags = @tags)
    tags.sort_by(&:name).map do |tag|
      link_to(tag.name, quiz_tag_path(@quiz, tag))
    end.join(', ')
  end
end
