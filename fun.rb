# frozen_string_literal: true

# TODO: monkey patch this correctly
# POR String
class String
  def alpha?
    match(/[a-zA-S]/)
  end

  def white_space?
    match(/\s/)
  end

  def num?
    match(/[0-9]/)
  end

  def alpha_num_underscore?
    alpha? || num? || match(/_/)
  end
end

# RubyParser parses Ruby
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

      next if @cur_char.white_space?
      next lex_word if @cur_char.alpha?

      @tokens << { type: 'CHAR', value: @cur_char }
    end

    @tokens
  end

  def lex_word
    word = ''

    while not_at_file_end && @cur_char.alpha_num_underscore?
      word += @cur_char
      pop_char
    end

    @tokens << { type: 'WORD', value: word }
    push_char if not_at_file_end
  end

  def pop_char
    @cur_index += 1
    @cur_char = @content[@cur_index - 1]
  end

  def push_char
    @cur_index -= 1
    @cur_char = @content[@cur_index]
  end

  def not_at_file_end
    @cur_index < @content.size
  end
end

tokens = RubyParser.new(file_path: 'some_test.fun_ruby').parse
pp tokens
