require 'test_helper'

class UtilsTest < ActiveSupport::TestCase

  test 'median' do
    assert_equal RailsPerformance::Utils.median([1,2,3]), 2
    assert_equal RailsPerformance::Utils.median([1,2,3,4]), 2.5
  end

end

