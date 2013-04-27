require 'cogdb'
require 'cogdb/store'
require 'docopt'
require 'uuid'
require 'base32/crockford'
require 'tempfile'

class CogDB::Command
  Usage = <<"..."
xlog

Usage:
  cogdb init [options]
  cogdb new [options]
  cogdb edit <id>
  cogdb find [--tag=<tag>]
  cogdb show <id>

Options:
  -h --help     Show this screen.
  --version     Show version.
  --root=<dir>  Directory of local CogDB
                  also COGDB_ROOT
  --content=<string>
  --tag=<tag>

...

  Commands = %w(
    init new edit find show
  )

  def initialize(options)
    get_options(options)
  end

  def run
    get_command_class.new(@options).run
  end

  def get_options(options)
    hash = Docopt.docopt(Usage)
    @options = {}
    hash.each do |k,v|
      case k
      when *Commands
        next unless v
        fail "more than one command specified" if @command
        @command = k
      when /^--(.*)$/
        @options[$1] = v if v
      when /^<(.*)>$/
        @options[$1] = v if v
      end
    end
  end

  def get_command_class
    CogDB::Command.const_get(@command.capitalize)
  end
end

class CogDB::Command::Base
  def initialize(options)
  end
end

class CogDB::Command::Init < CogDB::Command::Base
  def run
    @store.init
    puts <<"..."
Initialized new cogdb:
  #{@store.root}
You should verify and edit the 'conf/cogdb.yaml' file,
and read the README file.
...
  end
end

class CogDB::Command::New < CogDB::Command::Base
  def run
    @store.new
  end
end

class CogDB::Command::Edit < CogDB::Command::Base
  def run
    node = @store.get(@options['id'])
    text = node.to_cog
    temp = Tempfile.new("cognode.#{node.Id}")
    temp.write(text)
    temp.close
    editor = ENV['EDITOR'] or fail "No editor"
    system "#{editor} #{temp.path}"
    text = File.read temp.path
    node.from_cog(text)
    puts "#{node.Id} updated"
  end
end

class CogDB::Command::Find < CogDB::Command::Base
  def run
    @store.find
  end
end

class CogDB::Command::Show < CogDB::Command::Base
  def run
    @store.get
  end
end

class CogDB::Command::Base
  def initialize(options)
    @options = options
    root = options['root'] ||
      ENV['COGDB_ROOT'] ||
      '.'
    @store = CogDB::Store.new_store(root)
  end

  def run
    fail "The 'run' method must be subclassed in #{self.class}"
  end
end
