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

  # Return text converted from format to html
  def to_html(text, format = nil)
    format ||= :textile
  	if format == :textile
      RedCloth.new(text).to_html
    else
      text
    end
  end

  # Return html sanitized teaser for text, if format option is defined, text will be converted from format to html
  def teaser(text, options = {})
    options.reverse_merge!(:length => 150, :omission => '...')
    format = options.delete(:format) if options[:format]
    truncate(strip_tags(to_html(text.to_s, format)).strip, options)
  end

  def to_yes_no(value)
    value == true ? I18n.t("yes") : I18n.t("no")
  end

  def human_attribute_name(object, attribute, options = {})
    obj = object.is_a?(Array) ? object.first : object
    klass = obj.respond_to?(:klass) ? obj.klass : obj.class
    name = klass.respond_to?(:human_attribute_name) ? klass.human_attribute_name(attribute, options) : t(".#{attribute}")
    name || ''
  end

  def haml_tag_if(condition, *args, &block)
    if condition
      haml_tag *args, &block
     else
       yield
     end
  end

end

class Float
  def to_money
    sprintf("%0.0f", self)
  end

  def to_percent
    sprintf("%0.2f", self)
  end
end