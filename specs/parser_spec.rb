# frozen_string_literal: true

require './src/parser'

RSpec.describe RubyParser do
  describe '#parse' do
    context 'word' do
      it 'parses word with letters, underscore, and numbers at end of file' do
        word = 'some_crazy8_worD'

        actual = RubyParser.new(content: word).parse
        expected = [{ type: 'WORD', value: word }]

        expect(actual).to eq(expected)
      end

      it 'parses word with letters, underscore, and numbers not at end of file' do
        word = 'some_crazy8_worD'

        actual = RubyParser.new(content: "#{word} ").parse
        expected = [{ type: 'WORD', value: word }]

        expect(actual).to eq(expected)
      end
    end

    context 'number' do
      it 'parses integer at end of file' do
        number = '128320'

        actual = RubyParser.new(content: number).parse
        expected = [{ type: 'NUMBER', value: number }]

        expect(actual).to eq(expected)
      end

      it 'parses integer not at end of file' do
        number = '128320'

        actual = RubyParser.new(content: "#{number} ").parse
        expected = [{ type: 'NUMBER', value: number }]

        expect(actual).to eq(expected)
      end

      it 'parses float' do
        number = '1283.20'

        actual = RubyParser.new(content: number).parse
        expected = [{ type: 'NUMBER', value: number }]

        expect(actual).to eq(expected)
      end

      it 'parses float, but only once' do
        number = '1283.20.10'

        actual = RubyParser.new(content: number).parse
        expected = [
          { type: 'NUMBER', value: '1283.20' },
          { type: 'DOT', value: '.' },
          { type: 'NUMBER', value: '10' }
        ]

        expect(actual).to eq(expected)
      end
    end

    context 'symbol' do
      it 'parses dot' do
        expect(RubyParser.new(content: '.').parse).to eq([{ type: 'DOT', value: '.' }])
      end

      it 'parses colon' do
        expect(RubyParser.new(content: ':').parse).to eq([{ type: 'COLON', value: ':' }])
      end

      it 'parses left parenthesis' do
        expect(RubyParser.new(content: '(').parse).to eq([{ type: 'L_PAREN', value: '(' }])
      end

      it 'parses right parenthesis' do
        expect(RubyParser.new(content: ')').parse).to eq([{ type: 'R_PAREN', value: ')' }])
      end
    end

    context '+' do
      it 'parses single plus' do
        expect(RubyParser.new(content: '+').parse).to eq([{ type: 'PLUS', value: '+' }])
      end

      it 'parses plus equals' do
        expect(RubyParser.new(content: '+=').parse).to eq([{ type: 'PLUS_EQUALS', value: '+=' }])
      end

      it 'parses plus then equals' do
        expect(RubyParser.new(content: '+ =').parse).to eq([
                                                             { type: 'PLUS', value: '+' },
                                                             { type: 'EQUALS', value: '=' }
                                                           ])
      end
    end

    context '-' do
      it 'parses single minus' do
        expect(RubyParser.new(content: '-').parse).to eq([{ type: 'MINUS', value: '-' }])
      end

      it 'parses minus equals' do
        expect(RubyParser.new(content: '-=').parse).to eq([{ type: 'MINUS_EQUALS', value: '-=' }])
      end

      it 'parses minus then equals' do
        expect(RubyParser.new(content: '- =').parse).to eq([
                                                             { type: 'MINUS', value: '-' },
                                                             { type: 'EQUALS', value: '=' }
                                                           ])
      end
    end

    context '/' do
      it 'parses single divide' do
        expect(RubyParser.new(content: '/').parse).to eq([{ type: 'DIVIDE', value: '/' }])
      end

      it 'parses divide equals' do
        expect(RubyParser.new(content: '/=').parse).to eq([{ type: 'DIVIDE_EQUALS', value: '/=' }])
      end

      it 'parses divide then equals' do
        expect(RubyParser.new(content: '/ =').parse).to eq([
                                                             { type: 'DIVIDE', value: '/' },
                                                             { type: 'EQUALS', value: '=' }
                                                           ])
      end
    end

    context '*' do
      it 'parses single multiply' do
        expect(RubyParser.new(content: '*').parse).to eq([{ type: 'MULTIPLY', value: '*' }])
      end

      it 'parses multiply equals' do
        expect(RubyParser.new(content: '*=').parse).to eq([{ type: 'MULTIPLY_EQUALS', value: '*=' }])
      end

      it 'parses multiply then equals' do
        expect(RubyParser.new(content: '* =').parse).to eq([
                                                             { type: 'MULTIPLY', value: '*' },
                                                             { type: 'EQUALS', value: '=' }
                                                           ])
      end
    end

    context '@' do
      it 'parses single at' do
        expect(RubyParser.new(content: '@').parse).to eq([{ type: 'AT', value: '@' }])
      end

      it 'parses double at' do
        expect(RubyParser.new(content: '@@').parse).to eq([{ type: 'AT_AT', value: '@@' }])
      end

      it 'parses triple at' do
        expect(RubyParser.new(content: '@@@').parse).to eq([
                                                             { type: 'AT_AT', value: '@@' },
                                                             { type: 'AT', value: '@' }
                                                           ])
      end
    end

    context 'extended test: rubocop_cli.some_ruby' do
      it 'parses a variety of tokens' do
        content = File.open('./examples/rubocop_cli.some_ruby_2').read

        actual = RubyParser.new(content: content).parse
        expected = [
          hashtag,
          word('frozen_string_literal'),
          tok('COLON', ':'),
          word('true'),
          word('require'),
          tok('SINGLE_QUOTE', "'"),
          word('fileutils'),
          tok('SINGLE_QUOTE', "'"),
          word('module'),
          word('RuboCop'),
          hashtag,
          words('The CLI is a class responsible of handling all the command line interface'),
          hashtag,
          word('logic'),
          dot,
          words('class CLI STATUS_SUCCESS'),
          equalss,
          number('0'),
          word('STATUS_OFFENSES'),
          equalss,
          number('1'),
          word('STATUS_ERROR'),
          equalss,
          number('2'),
          word('STATUS_INTERRUPTED'),
          equalss,
          word('Signal'),
          dot,
          word('list'),
          tok('L_SQUARE_PAREN', '['),
          tok('SINGLE_QUOTE', "'"),
          word('INT'),
          tok('SINGLE_QUOTE', "'"),
          tok('R_SQUARE_PAREN', ']'),
          tok('PLUS', '+'),
          number('128'),
          word('DEFAULT_PARALLEL_OPTIONS'),
          equalss,
          tok('PERCENT', '%'),
          word('i'),
          tok('L_SQUARE_PAREN', '['),
          words('color debug display_style_guide display_time display_only_fail_level_offenses'),
          tok('R_SQUARE_PAREN', ']'),
          dot,
          words('freeze class Finished'),
          tok('LESS_THAN', '<'),
          word('StandardError'),
          tok('SEMI_COLON', ';'),
          words('end attr_reader'),
          tok('COLON', ':'),
          word('options'),
          tok('COMMA', ','),
          tok('COLON', ':'),
          words('config_store def initialize'),
          tok('AT', '@'),
          word('options'),
          equalss,
          tok('L_CURLY', '{'),
          tok('R_CURLY', '}'),
          tok('AT', '@'),
          word('config_store'),
          equalss,
          word('ConfigStore'),
          dot,
          words('new end'),
          hashtag,
          tok('AT', '@'),
          words('api public'),
          hashtag,
          hashtag,
          words('Entry point for the application logic'),
          dot,
          words('Here we'),
          hashtag,
          words('do the command line arguments processing and inspect'),
          hashtag,
          words('the target files'),
          dot,
          hashtag,
          hashtag,
          tok('AT', '@'),
          words('param args'),
          tok('L_SQUARE_PAREN', '['),
          word('Array'),
          tok('LESS_THAN', '<'),
          word('String'),
          tok('GREATER_THAN', '>'),
          tok('R_SQUARE_PAREN', ']'),
          words('command line arguments'),
          hashtag,
          tok('AT', '@'),
          word('return'),
          tok('L_SQUARE_PAREN', '['),
          word('Integer'),
          tok('R_SQUARE_PAREN', ']'),
          words('UNIX exit code'),
          hashtag,
          hashtag,
          word('rubocop'),
          tok('COLON', ':'),
          words('disable Metrics'),
          tok('DIVIDE', '/'),
          word('MethodLength'),
          tok('COMMA', ','),
          word('Metrics'),
          tok('DIVIDE', '/'),
          words('AbcSize def run'),
          tok('L_PAREN', '('),
          word('args'),
          equalss,
          word('ARGV'),
          tok('R_PAREN', ')'),
          number('10'),
          tok('PIPE_PIPE', '||'),
          word('create'),
          tok('EXCLAMATION_MARK', '!'),
          tok('L_PAREN', '('),
          word('foo'),
          tok('QUESTION_MARK', '?'),
          tok('R_PAREN', ')'),
          words('end end end')
        ].flatten

        expect(actual).to eq(expected)
      end
    end
  end

  def tok(type, value)
    { type: type, value: value }
  end

  def word(word)
    tok('WORD', word)
  end

  def words(sentence_string)
    sentence_string.split(' ').map { |w| word(w) }
  end

  def number(num)
    tok('NUMBER', num)
  end

  def hashtag
    tok('HASH_TAG', '#')
  end

  def equalss
    tok('EQUALS', '=')
  end

  def dot
    tok('DOT', '.')
  end
end
