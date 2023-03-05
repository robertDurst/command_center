require './src/parser.rb'

RSpec.describe RubyParser do
  describe '#parse' do
    context 'word' do
      it 'parses word with letters, underscore, and numbers at end of file' do
        word = 'some_crazy8_worD'

        actual = RubyParser.new(content: word).parse
        expected = [ { type: 'WORD', value: word } ]

        expect(actual).to eq(expected)
      end
      
      it 'parses word with letters, underscore, and numbers not at end of file' do
        word = 'some_crazy8_worD'

        actual = RubyParser.new(content: "#{word} ").parse
        expected = [ { type: 'WORD', value: word } ]

        expect(actual).to eq(expected)
      end
    end

    context 'number' do
      it 'parses integer at end of file' do
        number = '128320'

        actual = RubyParser.new(content: number).parse
        expected = [ { type: 'NUMBER', value: number } ]

        expect(actual).to eq(expected)
      end

      it 'parses integer not at end of file' do
        number = '128320'

        actual = RubyParser.new(content: "#{number} ").parse
        expected = [ { type: 'NUMBER', value: number } ]

        expect(actual).to eq(expected)
      end

      it 'parses float' do
        number = '1283.20'

        actual = RubyParser.new(content: number).parse
        expected = [ { type: 'NUMBER', value: number } ]

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
        expect(RubyParser.new(content: '.').parse).to eq([ {type: 'DOT', value: '.'} ])
      end

      it 'parses colon' do
        expect(RubyParser.new(content: ':').parse).to eq([ {type: 'COLON', value: ':'} ])
      end

      it 'parses left parenthesis' do
        expect(RubyParser.new(content: '(').parse).to eq([ {type: 'L_PAREN', value: '('} ])
      end

      it 'parses right parenthesis' do
        expect(RubyParser.new(content: ')').parse).to eq([ {type: 'R_PAREN', value: ')'} ])
      end
    end

    context '+' do
      it 'parses single plus' do
        expect(RubyParser.new(content: '+').parse).to eq([ {type: 'PLUS', value: '+'} ])
      end

      it 'parses plus equals' do
        expect(RubyParser.new(content: '+=').parse).to eq([ {type: 'PLUS_EQUALS', value: '+='} ])
      end
      
      it 'parses plus then equals' do
        expect(RubyParser.new(content: '+ =').parse).to eq([ 
          {type: 'PLUS', value: '+'},
          {type: 'EQUALS', value: '='}
        ])
      end
    end

    context '-' do
      it 'parses single minus' do
        expect(RubyParser.new(content: '-').parse).to eq([ {type: 'MINUS', value: '-'} ])
      end

      it 'parses minus equals' do
        expect(RubyParser.new(content: '-=').parse).to eq([ {type: 'MINUS_EQUALS', value: '-='} ])
      end
      
      it 'parses minus then equals' do
        expect(RubyParser.new(content: '- =').parse).to eq([ 
          {type: 'MINUS', value: '-'},
          {type: 'EQUALS', value: '='}
        ])
      end
    end

    context '/' do
      it 'parses single divide' do
        expect(RubyParser.new(content: '/').parse).to eq([ {type: 'DIVIDE', value: '/'} ])
      end

      it 'parses divide equals' do
        expect(RubyParser.new(content: '/=').parse).to eq([ {type: 'DIVIDE_EQUALS', value: '/='} ])
      end
      
      it 'parses divide then equals' do
        expect(RubyParser.new(content: '/ =').parse).to eq([ 
          {type: 'DIVIDE', value: '/'},
          {type: 'EQUALS', value: '='}
        ])
      end
    end

    context '*' do
      it 'parses single multiply' do
        expect(RubyParser.new(content: '*').parse).to eq([ {type: 'MULTIPLY', value: '*'} ])
      end

      it 'parses multiply equals' do
        expect(RubyParser.new(content: '*=').parse).to eq([ {type: 'MULTIPLY_EQUALS', value: '*='} ])
      end
      
      it 'parses multiply then equals' do
        expect(RubyParser.new(content: '* =').parse).to eq([ 
          {type: 'MULTIPLY', value: '*'},
          {type: 'EQUALS', value: '='}
        ])
      end
    end
    
    context '@' do
      it 'parses single at' do
        expect(RubyParser.new(content: '@').parse).to eq([ {type: 'AT', value: '@'} ])
      end

      it 'parses double at' do
        expect(RubyParser.new(content: '@@').parse).to eq([ {type: 'AT_AT', value: '@@'} ])
      end
      
      it 'parses triple at' do
        expect(RubyParser.new(content: '@@@').parse).to eq([ 
          {type: 'AT_AT', value: '@@'},
          {type: 'AT', value: '@'}
        ])
      end
    end
  end
end
