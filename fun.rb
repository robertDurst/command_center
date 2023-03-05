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
  end

  private

  def lex
    while not_at_file_end
      pop_char

      next if is_white_space?
      next lex_word if is_alpha?

      @tokens << { type: 'CHAR', value: @cur_char }
    end

    @tokens
  end

  def lex_word
    word = @cur_char

    while not_at_file_end
      pop_char

      unless is_alpha_num_underscore?
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
    @cur_char = @content[@cur_index - 1]
  end

  def push_char
    @cur_index -= 1
    @cur_char = @content[@cur_index]
  end

  def is_white_space?
    @cur_char.match(/\s/)
  end

  def is_alpha?
    @cur_char.match(/[a-zA-Z]/)
  end

  def is_num?
    @cur_char.match(/[0-9]/)
  end

  def is_alpha_num_underscore?
    is_alpha? || is_num? || @cur_char.match(/_/)
  end

  def not_at_file_end
    @cur_index < @content.size
  end
end

tokens = RubyParser.new(file_path: 'some_test.rb').parse
pp tokens

