module LabeledFormHelper  
  
  # Automatically include LabellingFormBuilder into form_for block
  def labeled_form_for(record_or_name_or_array, *args, &proc)
    options = args.extract_options!
    form_for(record_or_name_or_array,
      *(args << options.merge(:builder => LabellingFormBuilder)), &proc)
  end
end

# Customize FormBuilder's output
class LabellingFormBuilder < ActionView::Helpers::FormBuilder
  
  def check_box(attribute, options={})
    super + apply_label(attribute, options)
  end
  
  def date_select(attribute, options={})
    apply_label(attribute, options) + super
  end
  
  def datetime_select(attribute, options={})
    apply_label(attribute, options) + super
  end
  
  #def radio_button(attribute, tag_value, options={})
  #  super + apply_label(attribute, options)
  #end
  
  def radio_buttons_from_list(attribute, choices, options={})
    choices.each_with_index do |choice, i|
      result += radio_button(attribute, choice[1], { :label_text => choice[0] })
    end
    return result || ''
  end
  
  def select(attribute, choices, options={}, html_options={})
    apply_label(attribute, options) + super
  end
  
  def text_area(attribute, options={})
    # Change default number of rows
    if options[:rows].blank?
      options[:rows] = 6
    end
    apply_label(attribute, options) + super
  end
  
  def text_field(attribute, options={})
    apply_label(attribute, options) + super
  end
  
  def password_field(attribute, options={})
    apply_label(attribute, options) + super
  end
  
  private
  
  # Apply label to field
  def apply_label(attribute, options={})
    label(attribute, options[:label_text])
  end
  
  #def apply_radio_label(attribute, value) 
    #label(attribute, label_text)
    #value.to_s
    #label_tag(modelname_attributename_tagvalue, tagvalue)
    #classify.constantize
  #end
end
