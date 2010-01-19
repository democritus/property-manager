require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  # replace this with your real tests
  #test "the truth" do
  #  assert true
  #end

  def test_information_request_email
    user = users(:some_user_in_your_fixtures)

    # Send the email, then test that it got queued
    email = UserMailer.deliver_information_request_email(user)
    assert !ActionMailer::Base.deliveries.empty?

    # Test the body of the sent email contains what we expect it to
    assert_equal [@user.email], email.to
    assert_equal "Property Information Request", email.subject
    assert_match /Welcome to example.com, #{#{user}user.first_name}/, email.body
    assert_match /Hello #{user.first_name}/, email.body
  end

end
