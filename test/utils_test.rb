require 'test_helper'

class UtilsTest < ActiveSupport::TestCase

  test 'median' do
    assert_equal RP::Utils.median([1,2,3]), 2
    assert_equal RP::Utils.median([1,2,3,4]), 2.5
  end

end

