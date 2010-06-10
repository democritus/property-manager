require 'test_helper'

class CantonTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Canton.new.valid?
  end
end
