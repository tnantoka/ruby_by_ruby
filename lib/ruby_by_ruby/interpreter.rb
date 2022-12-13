# frozen_string_literal: true

module RubyByRuby
  class Interpreter
    def eval(source)
      eval_node(RubyVM::AbstractSyntaxTree.parse(source))
    end

    private

    def eval_node(node)
      case node.type
      when :BLOCK
        node.children.map { |child| eval_node(child) }.last
      when :FCALL
        p(eval_node(node.children[1].children[0]))
      when :LIT, :STR
        node.children[0]
      when :OPCALL
        receiver = eval_node(node.children[0])
        method = node.children[1]
        args = node.children[2].children.compact.map { eval_node(_1) }
        receiver.send(method, *args)
      when :SCOPE
        eval_node(node.children[2])
      else
        raise node.inspect
      end
    end
  end
end
