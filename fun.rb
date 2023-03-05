class RubyParser
  def initialize(file_path:)
    @content = File.open(file_path).read
    @cur_char = ''
    @cur_index = 0
    @tokens = []
  end

  def raw_content
    @content
  end

  def parse
    lex

    @tokens
  end

  private

  def lex
    while @cur_index < @content.size
      @cur_char = pop_char

      next if is_white_space?(@cur_char)
      next lex_word(@cur_char) if is_alpha?(@cur_char)

      @tokens << { type: 'CHAR', value: @cur_char }
    end
  end

  def lex_word(start_char)
    word = start_char

    while @cur_index < @content.size
      @cur_char = pop_char

      unless is_alpha_num_underscore?(@cur_char)
        @tokens << { type: 'WORD', value: word }
        push_char
        return
      end

      word << @cur_char
    end

    @tokens << { type: 'WORD', value: word }
  end

  def pop_char
    @cur_index += 1
    @content[@cur_index - 1]
  end

  def push_char
    @cur_index -= 1
  end

  def is_white_space?(char)
    char.match(/\s/)
  end

  def is_alpha?(char)
    char.match(/[a-zA-Z]/)
  end

  def is_num?(char)
    char.match(/[0-9]/)
  end

  def is_alpha_num_underscore?(char)
    is_alpha?(char) || is_num?(char) || char.match(/_/)
  end
end

tokens = RubyParser.new(file_path: 'some_test.rb').parse
pp tokens

