#
# Improvements to the String class.
#
# @author Arcterus
# @version 2012-09-11
#
class String
    #
    # Determines whether the String is entirely blank.
    #
    # @return [Boolean] whether or not the String is blank
    #
    def is_space
        self =~ /^[[:blank:]]+$/ ? true : false
    end
end

#
# Allows for C-like source code to be formatted using several
# popular bracketing styles.
#
# @author Arcterus
# @version 2012-09-11
#
class Format
    private

    @@keywords = ['else', 'while']
    @@version = nil

    #
    # Get the leading whitespace (the indentation) from the
    # input string.
    #
    # @param [String] str the string from which the
    #                 whitespace will be taken
    #
    # @return [String] the leading whitespace
    #
    def self.get_leading_space(str)
        result = ''
        str.each_char {|ch|
            if ch.is_space then
                result += ch
            else
                break
            end
        }
        return result
    end

    #
    # Format the input file using the Allman bracketing
    # style.
    #
    # @param [String] file the name of the input file
    # @param [File] output the output file
    # @param [String] indent the string to be used for
    #                        indentation
    # @param [Hash] options optional parameters that
    #                       affect output
    #
    def self.allman(file, output, indent, options={})
        IO.readlines(file).each {|line|
            indentlevel = self.get_leading_space(line).scan(/#{Regexp.quote(indent)}/).size + (options[:whitesmith] == true ? 1 : 0)
            if line =~ /^[[:blank:]]*}.*$/ then
                indentlevel.times do
                    output.print(indent)
                end
                output.puts('}')
                line.sub!(/}[[:blank:]]*/, '')
                next if line.lstrip == ''
            end
            if line =~ /[[:graph:]][[:blank:]]*{[[:blank:]]*$/ then
                output.puts(line.rstrip.chop.rstrip)
                indentlevel.times do
                    output.print(indent)
                end
                output.puts('{')
            else
                output.puts(line)
            end
        }
    end

    #
    # Format the input file using the UNIX bracketing
    # style.
    #
    # @param [String] file the name of the input file
    # @param [File] output the output file
    # @param [String] indent the string to be used for
    #                        indentation
    #
    def self.unix(file, output, indent)
        java_output = File.new(file + '.unix.tmp', 'w+')
        self.java(file, java_output, indent)
        java_output.seek(0, IO::SEEK_SET)
        IO.readlines(java_output).each {|line|
            indentlevel = self.get_leading_space(line).scan(/#{Regexp.quote(indent)}/).size
            if line =~ /^[[:blank:]]*[[:alpha:]][[:alnum:]]*[[:blank:]]+.*\(.*\)[[:blank:]]*\{[[:blank:]]*$/ then
                output.puts(line.rstrip.chop.rstrip)
                indentlevel.times do
                    output.print(indent)
                end
                output.puts('{')
            else
                output.puts(line)
            end
        }
        java_output.close
        File.delete(file + '.unix.tmp')
    end

    #
    # Format the input file using the Java bracketing
    # style.
    #
    # @param [String] file the name of the input file
    # @param [File] output the output file
    # @param [String] indent the string to be used for
    #                        indentation
    #
    def self.java(file, output, indent)
        prev_line = 'IGNORE THIS LINE'
        data = IO.readlines(file)
        index = 0
        indent_level = ''
        data.each {|line|
            if line =~ /^[[:blank:]]*{[[:blank:]]*$/ and
               not prev_line =~ /^[[:blank:]]*}[[:blank:]]*$/ then
                prev_line = prev_line.rstrip + ' {'
                line = 'IGNORE THIS LINE'
            else
                if prev_line =~ /^[[:blank:]]*}[[:blank:]]*$/ then
                    prev_line.lstrip!
                    indent_level.times do
                        output.print(indent)
                    end
                end
                @@keywords.each {|key|
                    if line =~ /^[[:blank:]]*#{Regexp.quote(key)}([[:blank:]]|\()?.*$/ and
                       prev_line =~ /^[[:blank:]]*}[[:blank:]]*$/ then
                        prev_line = prev_line.rstrip + ' ' + line.lstrip
                        if index + 1 < data.length and
                           data[index + 1] =~ /^[[:blank:]]*{[[:blank:]]*$/ then
                            prev_line = prev_line.rstrip + ' {'
                            data[index + 1] = 'IGNORE THIS LINE'
                        end
                        line = 'IGNORE THIS LINE'
                        break
                    end
                }
            end
            if prev_line != 'IGNORE THIS LINE' then
                output.puts(prev_line)
                indent_level = self.get_leading_space(prev_line).scan(/#{Regexp.quote(indent)}/).size
                indent_level -= 1 if indent_level != 0
            end
            prev_line = line
            index += 1
        }
        if prev_line != 'IGNORE THIS LINE' then
            if prev_line =~ /^[[:blank:]]*}[[:blank:]]*$/ then
                prev_line.lstrip!
                indent_level.times do
                    output.print(indent)
                end
            end
            output.puts(prev_line)
        end
    end

    def self.whitesmith(file, output, indent)
        self.allman(file, output, indent, :whitesmith => true)
    end

    public

    #
    # Allman bracketing style
    #
    # @return [Integer] the number designating the
    #                   Allman bracketing style
    #
    def self.ALLMAN
        1
    end

    #
    # UNIX bracketing style
    #
    # @return [Integer] the number designating the
    #                   UNIX bracketing style
    #
    def self.UNIX
        2
    end

    #
    # Java bracketing style
    #
    # @return [Integer] the number designating the
    #                   Java bracketing style
    #
    def self.JAVA
        3
    end

    #
    # (see ::JAVA)
    #
    def self.SUN
        self.JAVA
    end

    #
    # Whitesmith bracketing style
    #
    # @return [Integer] the number designating the
    #                   Whitesmith bracketing style
    def self.WHITESMITH
        4
    end

    #
    # Gives the current version of format.
    #
    # @return [String] the version of format
    #
    def self.VERSION
        if @@version == nil then
            file = File.dirname(__FILE__) + '/../VERSION'
            @@version = File.exists?(file) ? File.read(file) : ''
        end
        @@version
    end

    #
    # Formats the input file according to the input
    # options.
    #
    # @param [String] file the input file name
    # @param [Hash] options the options that determine
    #                       what is to happen to the
    #                       input file
    #
    def self.format(file, options={})
        indent = options[:indentation]
        if indent == nil then
            indent = '    '
        end
        output = nil
        case options[:style]
        when self.ALLMAN
            output = File.new(file + '.allman', 'w+')
            self.allman(file, output, indent)
        when self.WHITESMITH
            output = File.new(file + '.whitesmith', 'w+')
            self.whitesmith(file, output, indent)
        when self.UNIX
            output = File.new(file + '.unix', 'w+')
            self.unix(file, output, indent)
        when self.JAVA
            output = File.new(file + '.sun', 'w+')
            self.java(file, output, indent)
        else
            puts 'Defaulting to Java style formatting...'
            output = File.new(file + '.sun', 'w+')
            self.java(file, output, indent)
        end
        filename = output.path
        output.close
        if options[:replace] then
            File.delete(file)
            File.rename(filename, file)
        end
    end
end
