lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "poetry_reader/version"

Gem::Specification.new do |spec|
  spec.name          = "poetry_reader"
  spec.version       = PoetryReader::VERSION
  spec.authors       = ["'James Mobus'"]
  spec.email         = ["'mobusj@live.com'"]

  spec.summary       = "Poetry Reader uses the Poetry Foundation website to help you look at poems."
  spec.license       = "MIT"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency "nokogiri"
end
