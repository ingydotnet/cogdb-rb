require 'cogdb/store'

class CogDB::Store::Git < CogDB::Store
  def initialize root
    @root = File.expand_path root
  end

  def init
    system "(cd #{@root} && git init && mv .git .cogdb)"
    # fail "#{@root} is not empty. Cannot init a cogdb there." \
    #   unless Dir.glob("#{@root}/*").empty?
  end
    # git init
    # mv .git .cogdb
    # mkdir conf
    # copy template to conf/cogdb.yaml
    # mkdir node index
    # copy README to .

  def new
  end

  def find
  end
end
