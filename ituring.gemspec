# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ituring/version'

Gem::Specification.new do |spec|
  spec.name          = "ituring"
  spec.version       = Ituring::VERSION
  spec.authors       = ["ken"]
  spec.email         = ["block24block@gmail.com"]

  spec.summary       = %q{fetch all books infoon ituring.com.cn}
  spec.homepage      = "https://github.com/turnon/ituring"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"

  spec.add_dependency  "parallel", "~> 1.11"
  spec.add_dependency  "page_by_page", "~> 0.1"
  spec.add_dependency  "nokogiri", "~> 1.7"
end
