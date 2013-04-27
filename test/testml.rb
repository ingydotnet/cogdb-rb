require 'minitest/autorun'
require 'testml'
require_relative 'testml_bridge'

class TestMLTestCase < MiniTest::Unit::TestCase
  def test
    TestML.new(
      testml: testml,
      bridge: TestMLBridge,
    ).run(self)
  end

  def testml
    <<'...'
%TestML 0.1.0

Plan = 2

cog_test_dir = '/tmp/cogdb-test'
ensure_empty_dir_exists(cog_test_dir)
env_set('COGDB_ROOT', cog_test_dir)

cmd = 'cogdb init'
run(cmd).OK

dir_exists(concat(cog_test_dir, '/.cogdb')).OK
clean_up_dir(cog_test_dir)
...
  end
end
