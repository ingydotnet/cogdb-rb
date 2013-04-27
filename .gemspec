# encoding: utf-8

GemSpec = Gem::Specification.new do |gem|
  gem.name = 'cogdb'
  gem.version = '0.0.1'
  gem.license = 'MIT'
  gem.required_ruby_version = '>= 1.9.1'

  gem.authors << 'Ingy döt Net'
  gem.email = 'ingy@ingy.net'
  gem.summary = 'A Thoughtful Data Store'
  gem.description = <<-'.'
CogDB is a framework for storing and sharing your ideas in a permanently
addressable and friendly manner.
.
  gem.homepage = 'http://cogdb.org'

  gem.files = `git ls-files`.lines.map{|l|l.chomp}

  gem.add_dependency 'docopt', '>= 0.5.0'
  gem.add_dependency 'ruby-uuid', '>= 0.0.1'
  gem.add_dependency 'base32-crockford', '>= 0.1.0'
  gem.add_dependency 'pegex', '>= 0.0.3'

  gem.add_development_dependency 'testml', '>= 0.0.2'
  gem.add_development_dependency 'pry-plus'
  gem.add_development_dependency 'wxyz'
end
