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
end
