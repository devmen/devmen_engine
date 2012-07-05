module ApplicationHelper

  # Return a title on per-page basis.
  def title
    base_title = "Devmen Engine"
    if @title.nil?
      base_title
    else
      "#{@title} - #{base_title}"
    end
  end

  # Return content converted from format to html
  def self.to_html(content, format = :textile)    
    if format == :textile      
      RedCloth.new(content).to_html
    else      
      content
    end
  end

  def to_html(content, format = :textile)
  	ApplicationHelper.to_html(content, format)
  end

end
