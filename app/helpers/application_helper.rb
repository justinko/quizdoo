# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def page_title
    ary = []
    ary << 'Quizdoo'
    
    if @quiz and not @quiz.title == @page_title
      ary << @quiz.title
    end
    
    ary << @page_title
    
    ary.reverse.join(' &ndash; ')
  end
  
  def markdown
    link_to 'Formatting Help', 'http://effectif.com/nesta/markdown-cheat-sheet', :popup => true
  end
  
  def no_items(text)
    content_tag(:div, text, :class => 'no_items')
  end  
end
