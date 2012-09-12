require 'helper'

class TestFormat < Test::Unit::TestCase
    def test_simple
        Dir.chdir('lib') do
            Format.format(Dir.pwd + '/../test/test.java', :indentation => '    ', :style => Format.ALLMAN)
            Format.format(Dir.pwd + '/../test/test.java.allman', :style => Format.JAVA)
            test = IO.read(Dir.pwd + '/../test/test.java')
            allman = IO.read(Dir.pwd + '/../test/test.java.allman')
            sun = IO.read(Dir.pwd + '/../test/test.java.allman.sun')
            correct_ugly = IO.read(Dir.pwd + '/../test/test.java.correct_ugly')
            assert_equal(test, sun)
            assert_equal(allman, correct_ugly)
            # TODO: add (more random) tests here
        end
    end
end
