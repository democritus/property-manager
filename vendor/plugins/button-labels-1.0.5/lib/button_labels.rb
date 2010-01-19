# ButtonLabels
module ActionView
  module Helpers
    module FormHelper
      # Returns a radio button tag for accessing a specified attribute (identified by +method+) on an object
      # assigned to the template (identified by +object+). If the current value of +method+ is +tag_value+ the
      # radio button will be checked. Additional options on the input tag can be passed as a
      # hash with +options+.
      # Example (call, result). Imagine that @post.category returns "rails":
      #   radio_button("post", "category", "rails")
      #     <input type="radio" id="post_category" name="post[category]" value="rails" checked="checked" />
      #   radio_button("post", "category", "java", :label => "Java")
      #     <input type="radio" id="post_category" name="post[category]" value="java"><label for="post_category">Java</label></input>
      #
      def radio_button_with_label(object_name, method, tag_value, options = {})
        InstanceTag.new(object_name, method, self, options.delete(:object)).to_radio_button_tag(tag_value, options)
      end

      # Returns a checkbox tag tailored for accessing a specified attribute (identified by +method+) on an object
      # assigned to the template (identified by +object+). It's intended that +method+ returns an integer and if that
      # integer is above zero, then the checkbox is checked. Additional options on the input tag can be passed as a
      # hash with +options+. The +checked_value+ defaults to 1 while the default +unchecked_value+
      # is set to 0 which is convenient for boolean values. Usually unchecked checkboxes don't post anything.
      # We work around this problem by adding a hidden value with the same name as the checkbox.
      #
      # Example (call, result). Imagine that @post.validated? returns 1:
      #   check_box("post", "validated")
      #     <input type="checkbox" id="post_validate" name="post[validated]" value="1" checked="checked" />
      #     <input name="post[validated]" type="hidden" value="0" />
      #
      # Example (call, result). Imagine that @puppy.gooddog returns no:
      #   check_box("puppy", "gooddog", {}, "yes", "no")
      #     <input type="checkbox" id="puppy_gooddog" name="puppy[gooddog]" value="yes" />
      #     <input name="puppy[gooddog]" type="hidden" value="no" />
      #
      # Example (call, result, :label). Like first example, with label
      #   check_box("post", "validated", :label => "Label")
      #     <input type="checkbox" id="post_validate" name="post[validated]" value="1" checked="checked"><label for="post_validate">Label</label></input>
      #     <input name="post[validated]" type="hidden" value="0" />
      def check_box_with_label(object_name, method, options = {}, checked_value = "1", unchecked_value = "0")
        InstanceTag.new(object_name, method, self, options.delete(:object)).to_check_box_tag(options, checked_value, unchecked_value)
      end

      alias_method_chain :radio_button, :label
      alias_method_chain :check_box, :label
    end
    
    module FormTagHelper
      # Creates a radio button.
      #
      # Options:
      # * <tt>:label</tt> - A string specifying the content of the tag.
      #     # Outputs <input id="people" name="people" type="radio" value="david"><label for="people">david</label></input>
      #     <%=  radio_button_tag "people", "david", false, "label" => "david" %>
      def radio_button_tag_with_label(name, value, checked = false, options = {})
        pretty_tag_value = value.to_s.gsub(/\s/, "_").gsub(/(?!-)\W/, "").downcase
        pretty_name = name.to_s.gsub(/\[/, "_").gsub(/\]/, "")        
        html_options = { "type" => "radio", "name" => name, "id" => "#{pretty_name}_#{pretty_tag_value}", "value" => value }.update(options.stringify_keys)
        html_options["checked"] = "checked" if checked
        if (options.has_key?(:label))
          content_tag :input, content_tag(:label, html_options.delete("label"), :for => "#{pretty_name}_#{pretty_tag_value}"), html_options
       else
          tag :input, html_options
        end
      end

      #
      # Options:
      # * <tt>:label</tt> - A string specifying the content of the tag.
      def check_box_tag_with_label(name, value, checked = false, options = {})
        html_options = { "type" => "checkbox", "name" => name, "id" => sanitize_to_id(name), "value" => value }.update(options.stringify_keys)
        html_options["checked"] = "checked" if checked
        if (options.has_key?(:label))
          content_tag :input, content_tag(:label, html_options.delete("label"), :for => name), html_options
       else
          tag :input, html_options
        end
      end

      alias_method_chain :radio_button_tag, :label
      alias_method_chain :check_box_tag, :label
    end
    class InstanceTag #:nodoc:
      alias_method :to_radio_button_tag_no_label, :to_radio_button_tag
      def to_radio_button_tag(tag_value, options = {})
        options = DEFAULT_RADIO_OPTIONS.merge(options.stringify_keys)
        options["type"]     = "radio"
        options["value"]    = tag_value
              if options.has_key?("checked")
          cv = options.delete "checked"
          checked = cv == true || cv == "checked"
        else
          checked = self.class.radio_button_checked?(value(object), tag_value)
        end
        options["checked"]  = "checked" if checked
        pretty_tag_value    = tag_value.to_s.gsub(/\s/, "_").gsub(/\W/, "").downcase
        options["id"]     ||= defined?(@auto_index) ?             
          "#{@object_name}_#{@auto_index}_#{@method_name}_#{pretty_tag_value}" :
          "#{@object_name}_#{@method_name}_#{pretty_tag_value}"
        add_default_name_and_id(options)
        if options.has_key?("label")
          content_tag("input", content_tag(:label, options.delete("label"), :for => options["id"]), options)
        else
          tag("input", options)
        end
      end

      alias_method :to_check_box_tag_no_label, :to_check_box_tag
      def to_check_box_tag(options = {}, checked_value = "1", unchecked_value = "0")
        options = options.stringify_keys
        options["type"]     = "checkbox"
        options["value"]    = checked_value
        if options.has_key?("checked")
          cv = options.delete "checked"
          checked = cv == true || cv == "checked"
        else
          checked = self.class.check_box_checked?(value(object), checked_value)
        end
        options["checked"] = "checked" if checked
        add_default_name_and_id(options)
        if options.has_key?("label")
          content_tag("input", content_tag(:label, options.delete("label"), :for => options["id"]), options)
        else
          tag("input", options)
        end << tag("input", "name" => options["name"], "type" => "hidden", "value" => unchecked_value)
      end
    end
  end
end

