# frozen_string_literal: true

# rubocop:disable Lint/DuplicateBranch, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
module RubyByRuby
  class Interpreter
    def eval(source)
      genv = {
        p: %i[builtin p]
      }
      lenv = {}
      eval_node(RubyVM::AbstractSyntaxTree.parse(source), genv, lenv)
    end

    private

    def eval_node(node, genv, lenv)
      case node.type
      when :ATTRASGN
        receiver = eval_node(node.children[0], genv, lenv)
        method = node.children[1]
        args = node.children[2].children.compact.map { eval_node(_1, genv, lenv) }
        receiver.send(method, *args)
      when :BLOCK
        node.children.map { eval_node(_1, genv, lenv) }.last
      when :CALL
        receiver = eval_node(node.children[0], genv, lenv)
        method = node.children[1]
        args = node.children[2].children.compact.map { eval_node(_1, genv, lenv) }
        receiver.send(method, *args)
      when :CASE
        value = eval_node(node.children[0], genv, lenv)
        condition = node.children[1]
        result = nil
        loop do
          if condition.children[0].children.compact.any? { eval_node(_1, genv, lenv) == value }
            result = eval_node(condition.children[1], genv, lenv)
          else
            condition = condition.children[2]
          end

          break if !result.nil? || condition.nil?
        end
        result
      when :DEFN
        genv[node.children[0]] = ['user_defined', node.children[1].children[0], node.children[1].children[2]]
      when :FCALL
        method = genv[node.children[0]]
        args = node.children[1].children.compact.map { eval_node(_1, genv, lenv) }
        if method[0] == :builtin
          send(method[1], *args)
        else
          new_lenv = {}
          method[1].each_with_index { |name, i| new_lenv[name] = args[i] }
          eval_node(method[2], genv, new_lenv)
        end
      when :IF
        if eval_node(node.children[0], genv, lenv)
          eval_node(node.children[1], genv, lenv)
        else
          eval_node(node.children[2], genv, lenv)
        end
      when :LASGN
        lenv[node.children[0]] = eval_node(node.children[1], genv, lenv)
      when :LIST
        node.children.compact.map { eval_node(_1, genv, lenv) }
      when :LIT
        node.children[0]
      when :LVAR
        lenv[node.children[0]]
      when :OPCALL
        receiver = eval_node(node.children[0], genv, lenv)
        method = node.children[1]
        args = node.children[2].children.compact.map { eval_node(_1, genv, lenv) }
        receiver.send(method, *args)
      when :SCOPE
        eval_node(node.children[2], genv, lenv)
      when :STR
        node.children[0]
      when :UNTIL
        eval_node(node.children[1], genv, lenv) until eval_node(node.children[0], genv, lenv)
      when :WHILE
        eval_node(node.children[1], genv, lenv) while eval_node(node.children[0], genv, lenv)
      else
        raise node.inspect
      end
    end
  end
end
# rubocop:enable Lint/DuplicateBranch, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
