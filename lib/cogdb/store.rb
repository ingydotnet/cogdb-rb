require 'cogdb'

class CogDB::Store
  attr_accessor 'root'
  def self.new_store(root)
    fail "Don't know how to make a CogDB::Store from '#{root}'" \
      unless Dir.exists? root
    require 'cogdb/store/git'
    return CogDB::Store::Git.new(root)
  end
end
