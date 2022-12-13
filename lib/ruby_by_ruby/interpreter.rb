# frozen_string_literal: true

# rubocop:disable Lint/DuplicateBranch, Metrics/CyclomaticComplexity
module RubyByRuby
  class Interpreter
    def eval(source)
      env = {}
      eval_node(RubyVM::AbstractSyntaxTree.parse(source), env)
    end

    private

    def eval_node(node, env)
      case node.type
      when :BLOCK
        node.children.map { |child| eval_node(child, env) }.last
      when :FCALL
        p(eval_node(node.children[1].children[0], env))
      when :IF
        if eval_node(node.children[0], env)
          eval_node(node.children[1], env)
        else
          eval_node(node.children[2], env)
        end
      when :LASGN
        env[node.children[0]] = eval_node(node.children[1], env)
      when :LIT
        node.children[0]
      when :LVAR
        env[node.children[0]]
      when :OPCALL
        receiver = eval_node(node.children[0], env)
        method = node.children[1]
        args = node.children[2].children.compact.map { eval_node(_1, env) }
        receiver.send(method, *args)
      when :SCOPE
        eval_node(node.children[2], env)
      when :STR
        node.children[0]
      else
        raise node.inspect
      end
    end
  end
end
# rubocop:enable Lint/DuplicateBranch, Metrics/CyclomaticComplexity
