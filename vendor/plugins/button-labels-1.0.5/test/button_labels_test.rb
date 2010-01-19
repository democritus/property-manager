require File.dirname(__FILE__) + '/abstract_unit'

class FormHelperTest < Test::Unit::TestCase #:nodoc:
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::FormTagHelper
  def test_radio_button_with_label
    actual = radio_button("post", "title", "Goodbye World", :label => "Goodby World")
    expected = %(<input id="post_title_goodbye_world" name="post[title]" type="radio" value="Goodbye World"><label for="post_title_goodbye_world">Goodby World</label></input>)
    assert_dom_equal expected, actual
  end
  def test_radio_button_tag_with_label
    actual = radio_button_tag "people", "david", false, :label => "david"
    expected = %(<input id="people_david" name="people" type="radio" value="david"><label for="people_david">david</label></input>)
    assert_dom_equal expected, actual
  end
  def test_check_box_with_label
    actual = check_box("post", "title", :label => "Goodby World")
    expected = %(<input id="post_title" name="post[title]" type="checkbox" value="1"><label for="post_title">Goodby World</label></input><input name="post[title]" type="hidden" value="0" />)
    assert_dom_equal expected, actual
  end
  def test_check_box_tag_with_label
    actual = check_box_tag "people", "david", false, :label => "david"
    expected = %(<input id="people" name="people" type="checkbox" value="david"><label for="people">david</label></input>)
    assert_dom_equal expected, actual
  end
end
