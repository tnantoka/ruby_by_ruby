# frozen_string_literal: true

require 'js'

document = JS.global[:window][:document]
output = document.querySelector('[data-id="output"]')
output[:innerHTML] = ''

interpreter = RubyByRuby::Interpreter.new
output.append("1 + 1 = #{interpreter.eval('1 + 1')}\n")

code = <<~CODE
  def random
    val = rand(10)
    [val, val % 2 == 0 ? 'odd' : 'even'].join(': ')
  end
  random()
CODE
output.append("#{interpreter.eval(code)}\n")
