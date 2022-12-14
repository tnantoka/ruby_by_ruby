# frozen_string_literal: true

RSpec.describe RubyByRuby do
  let(:interpreter) { RubyByRuby::Interpreter.new }

  describe 'arithmetic operation' do
    it { expect(interpreter.eval('1 + 1')).to eq(2) }
    it { expect(interpreter.eval('1 - 1')).to eq(0) }
    it { expect(interpreter.eval('4 * 2')).to eq(8) }
    it { expect(interpreter.eval('4 / 2')).to eq(2) }
    it { expect(interpreter.eval('5 % 2')).to eq(1) }
    it { expect(interpreter.eval('2 ** 3')).to eq(8) }
    it { expect(interpreter.eval('(1 + 2) / 3 * 4 * (56 / 7 + 8 + 9)')).to eq(100) }
  end

  describe 'comparison operator' do
    it { expect(interpreter.eval('1 < 2')).to eq(true) }
    it { expect(interpreter.eval('1 <= 2')).to eq(true) }
    it { expect(interpreter.eval('1 > 2')).to eq(false) }
    it { expect(interpreter.eval('1 >= 2')).to eq(false) }
    it { expect(interpreter.eval('1 == 2')).to eq(false) }
    it { expect(interpreter.eval('1 != 2')).to eq(true) }
  end

  describe 'function call' do
    it { expect { interpreter.eval("p('test')") }.to output("\"test\"\n").to_stdout }
  end

  describe 'statements' do
    let(:source) do
      <<~SRC
        puts(1)
        puts(2)
      SRC
    end
    it do
      expect { interpreter.eval(source) }.to output("1\n2\n").to_stdout
    end
  end

  describe 'variables' do
    let(:source) do
      <<~SRC
        a = 1
        puts(a)
      SRC
    end
    it do
      expect { interpreter.eval(source) }.to output("1\n").to_stdout
    end
  end

  describe 'if' do
    let(:source) do
      <<~SRC
        if 1 > 2
          1
        elsif 2 < 3
          2
        else
          3
        end
      SRC
    end
    it do
      expect(interpreter.eval(source)).to eq(2)
    end
  end

  describe 'while' do
    let(:source) do
      <<~SRC
        i = 0
        while i < 5
          i += 1
        end
        i
      SRC
    end
    it do
      expect(interpreter.eval(source)).to eq(5)
    end
  end

  describe 'case' do
    let(:source) do
      <<~SRC
        case 3
        when 1
          'a'
        when 2, 3
          'b'
        else
          'c'
        end
      SRC
    end
    it do
      expect(interpreter.eval(source)).to eq('b')
    end
  end
end
