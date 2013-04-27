$: << 'lib'
require 'cogdb/store/git'

require 'testml/bridge'
require 'testml/util'
require 'fileutils'

class TestMLBridge < TestML::Bridge
  include TestML::Util

  def if cond, when_true, when_false
    f =
      if cond.bool.value
        when_true
      else
        when_false
      end
    bool(runtime.run_function f, [])
  end

  def warn str
    Kernel.warn str.value
    str ''
  end

  def call_tml func
    send func
  end

  def run cmd
    output = IO.popen(cmd.value.split) do |io|
      io.read
    end
    fail "#{cmd.value} returned #{$?.to_i}, outputting:\n#{output}" \
      unless $?.success?
    str(output)
  end

  def env_set name, val
    ENV[name.value] = val.value
    TestML::Constant::True
  end

  def dir_exists dir
    TestML::Bool.new(Dir.exists? dir.value)
  end

  def ensure_empty_dir_exists dir
    clean_up_dir dir if Dir.exists? dir.value
    Dir.mkdir dir.value
    TestML::Constant::True
  end

  def exists_under_cogdb_test_dir filename
    TestML::Bool.new(File.exists? filename.value)
  end

  def clean_up_dir path
    fail unless path.value[/^\/tmp/]
    FileUtils.rm_r path.value
    TestML::Constant::True
  end

  def concat a, b
    str(a.value + b.value)
  end

  def dir_exists path
    TestML::Bool.new(Dir.exists? path.value)
  end
end

__END__
class TestGitStore < MiniTest::Unit::TestCase
  COG_TEST_DIR = '/tmp/cogdb-test'
  def test_init
    Dir.mkdir COG_TEST_DIR
    Dir.chdir COG_TEST_DIR do
      s = CogDB::Store::Git.new '.'
      s.init
      assert Dir.exists?('.cogdb'), '.cogdb/ existence'
    end
  ensure
    fail "COG_TEST_DIR ('#{COG_TEST_DIR}') not in /tmp" \
      unless COG_TEST_DIR.match /^\/tmp/
    FileUtils.rm_r COG_TEST_DIR
  end
end

