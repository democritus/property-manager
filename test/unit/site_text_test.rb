require 'test_helper'

class SiteTextTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert SiteText.new.valid?
  end
end
