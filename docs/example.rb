# frozen_string_literal: true

require 'js'

example = JS.global[:window][:example]
example.reset

interpreter = RubyByRuby::Interpreter.new
example.log("1 + 1 = #{interpreter.eval('1 + 1')}")

code = <<~CODE
  def random
    val = rand(10)
    [val, val % 2 == 0 ? 'odd' : 'even'].join(': ')
  end
  random()
CODE
example.log(interpreter.eval(code))
