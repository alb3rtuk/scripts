require 'test/unit'
require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'

class TestUtilities < Test::Unit::TestCase

    def testConfigFileExists
        assert_equal(File.exists?('/Users/Albert/bin/config/private.rb'), true)
    end

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

    def testGetKeysInHash
        testHash = {}
        testHash[1] = 'testValue'
        testHash[2] = 'testValue'
        testHash['abc'] = 'testValue'
        testHash['def'] = 'testValue'
        assert_equal(Array[1, 2, 'abc', 'def'], getKeysInHash(testHash))
    end

    def testIsWholeNumber
        assert_equal(isWholeNumber(12), true)
        assert_equal(isWholeNumber(12.3), false)
        assert_equal(isWholeNumber('12'), true)
        assert_equal(isWholeNumber('12.3'), false)
        assert_equal(isWholeNumber('abc'), false)
        assert_equal(isWholeNumber(Array.new), false)
        assert_equal(isWholeNumber("#{(3 + 3)}"), true)
        puts "\n\x1B[90mPass: testIsWholeNumber\x1B[0"
    end

    def testGetCharAt
        testString = "abcdefgh"
        assert_equal(getCharAt(3, testString), 'c')
        assert_equal(getCharAt('5', testString), 'e')
        assert_equal(getCharAt("#{(3 + 3)}", testString), 'f')
        assert_raise RuntimeError do
            getCharAt(3.3, testString)
        end
        assert_raise RuntimeError do
            getCharAt("3.3", testString)
        end
    end

    def testDiffBetweenDatesInDays
        assert_equal(diffBetweenDatesInDays('2013-10-29', '2013-12-10'), -42)
        assert_equal(diffBetweenDatesInDays('2013-12-10', '2013-10-29'), 42)
        assert_equal(diffBetweenDatesInDays('2013-12-10') < 0, true)
        assert_equal(diffBetweenDatesInDays(), 0)
        assert_raise ArgumentError do
            assert_equal(diffBetweenDatesInDays('2013/10/29', '2013/12/10'), 42)
        end
        assert_raise ArgumentError do
            assert_equal(diffBetweenDatesInDays('abc', 'def'), 42)
        end
    end

    def testToCurrency
        assert_equal(toCurrency(4123), '£4,123.00')
        assert_equal(toCurrency('4123'), '£4,123.00')
        assert_equal(toCurrency(4123.123), '£4,123.12')
        assert_equal(toCurrency('4123.123'), '£4,123.12')
        assert_equal(toCurrency('4123.0', '$', '-'), '$4-123.00')
        assert_equal(toCurrency(0), '£0.00')
        assert_equal(toCurrency('0'), '£0.00')
        assert_equal(toCurrency('abcz'), '£0.00')
        assert_equal(toCurrency(-55.01), '-£55.01')
        assert_equal(toCurrency(0 - 55.01), '-£55.01')
        assert_equal(toCurrency('-55.01'), '-£55.01')
    end

end
