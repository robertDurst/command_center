# frozen_string_literal: true

# TODO: monkey patch this correctly
# POR String
class String
  def alpha?
    match?(/[a-zA-Z]/)
  end

  def white_space?
    match?(/\s/)
  end

  def num?
    match?(/[0-9]/)
  end

  def alpha_num_underscore?
    alpha? || num? || match?(/_/)
  end
end

# RubyParser parses Ruby
class RubyParser
  def initialize(content:)
    @content = content
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
      next lex_num if @cur_char.num?

      @tokens << lex_symbol
    end

    @tokens
  end

  def lex_symbol
    case @cur_char
    when ':'
      { type: 'COLON', value: @cur_char }
    when ')'
      { type: 'R_PAREN', value: @cur_char }
    when '('
      { type: 'L_PAREN', value: @cur_char }
    when '#'
      { type: 'HASH_TAG', value: @cur_char }
    when '.'
      { type: 'DOT', value: @cur_char }
    when '='
      lex_extended_symbol('=', 'EQUALS', 'EQUALS_EQUALS')
    when '-'
      lex_extended_symbol('=', 'MINUS', 'MINUS_EQUALS')
    when '+'
      lex_extended_symbol('=', 'PLUS', 'PLUS_EQUALS')
    when '*'
      lex_extended_symbol('=', 'MULTIPLY', 'MULTIPLY_EQUALS')
    when '/'
      lex_extended_symbol('=', 'DIVIDE', 'DIVIDE_EQUALS')
    when '@'
      lex_extended_symbol('@', 'AT', 'AT_AT')
    else
      { type: 'CHAR', value: @cur_char }
    end
  end

  def lex_extended_symbol(extension, type, type_extended)
      if @content[@cur_index] == extension
        @cur_index += 1
        { type: type_extended, value: "#{@cur_char}#{extension}" }
      else
        { type: type, value: @cur_char }
      end
  end

  def lex_num
    num = ''
    decimal = false

    while !@cur_char.nil? && (@cur_char.num? || (@cur_char.match?(/\./) && !decimal))
      num += @cur_char
      decimal = true if @cur_char.match?(/\./)
      pop_char
    end


    @tokens << { type: 'NUMBER', value: num }
    push_char if not_at_file_end
  end

  def lex_word
    word = ''

    while !@cur_char.nil? && @cur_char.alpha_num_underscore?
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

