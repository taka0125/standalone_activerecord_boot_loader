# frozen_string_literal: true

require_relative "lib/standalone_activerecord_boot_loader/version"

Gem::Specification.new do |spec|
  spec.name          = "standalone_activerecord_boot_loader"
  spec.version       = StandaloneActiverecordBootLoader::VERSION
  spec.authors       = ["Takahiro Ooishi"]
  spec.email         = ["taka0125@gmail.com"]

  spec.summary       = "ActiveRecordを単体で動かす時に使う起動処理"
  spec.description   = "ActiveRecordを単体で動かす時に使う起動処理"
  spec.homepage      = "https://github.com/taka0125/standalone_activerecord_boot_loader"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.files         = Dir['LICENSE', 'README.md', 'lib/**/*', 'exe/**/*', 'sig/**/*']
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "zeitwerk"
  spec.add_dependency "activerecord"
end
