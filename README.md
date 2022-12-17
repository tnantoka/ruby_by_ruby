# Ruby by Ruby

ruby_by_ruby is a toy ruby ​​interpreter with [RubyVM::AbstractSyntaxTree](https://ruby-doc.org/3.1.3/RubyVM/AbstractSyntaxTree.html).

## Demo on [ruby.wasm](https://github.com/ruby/ruby.wasm)

https://tnantoka.github.io/ruby_by_ruby/

## Usage

```ruby
interpreter = RubyByRuby::Interpreter.new
interpreter.eval('1 + 1') # => 2
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.
## Acknowledgments

https://www.lambdanote.com/products/ruby-ruby
