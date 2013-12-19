require 'test/unit'
require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'

class TestUtilities < Test::Unit::TestCase

    def testVerifyInput
        testArray = Array['foo', 'bar']
        assert_equal(verifyInput(testArray, 'foo'), true)
        assert_equal(verifyInput(testArray, 'bar'), true)
        assert_raise RuntimeError do
            verifyInput(testArray, 'shouldFail')
        end
        puts "\n\x1B[90mPass: testVerifyInput\x1B[0m\n\n"
    end

    def testInArray
        testArray = Array['foo', 'bar']
        assert_equal(inArray(testArray, 'foo'), true)
        assert_equal(inArray(testArray, 'bar'), true)
        assert_equal(inArray(testArray, 'BAR', true), true)
        assert_equal(inArray(testArray, 'BAR'), false)
        assert_equal(inArray(testArray, 'shouldReturnFals'), false)
        assert_nothing_raised RuntimeError do
            inArray(testArray, 'shouldNotRaiseException')
        end
        puts "\n\x1B[90mPass: testInArray\x1B[0"
    end

end
