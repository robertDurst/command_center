class RubyParser
  def initialize(file_path:)
    @content = File.open(file_path).read
    @cur_char = ''
    @cur_index = 0
  end

  def raw_content
    @content
  end

  def parse
    parse_program
  end

  private

  def parse_program
    { program: parse_top }
  end

  def parse_top
    tops = []

    while @cur_index <= @content.size
      @cur_char = @content[@cur_index]
      # print @cur_char
      @cur_index += 1
    end

    tops
  end

  def parse_method
  end
end

tokens = RubyParser.new(file_path: 'some_test.rb').parse
pp tokens

