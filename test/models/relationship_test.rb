require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    @second_user = users(:archer)
    @third_user = users(:lana)
    @relationship = Relationship.new(follower_id: @user.id, following_id: @second_user.id)
  end

  test "should be valid" do
    assert @relationship.valid?
  end

  test "should require a follower_id" do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  test "should require a following_id" do
    @relationship.following_id = nil
    assert_not @relationship.valid?
  end

end
