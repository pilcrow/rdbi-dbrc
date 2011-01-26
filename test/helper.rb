require 'rubygems'
require 'test/unit'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'fauxlib'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rdbi-dbrc'

class Test::Unit::TestCase
  def setup
    ENV["DBRC"] = File.join(File.dirname(__FILE__), 'dbrc')
  end

  private
  def module_loaded?(name)
    eval "defined?(#{name}) && #{name}.is_a?(::Module)"
  end
end
