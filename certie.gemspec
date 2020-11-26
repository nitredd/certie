Gem::Specification.new do |spec|
	spec.authors = ["Katkam Nitin Reddy"]
	spec.name = "certie"
	spec.version = "0.0.5"
	spec.date = '2020-11-27'
  spec.summary = "A utility for generating certificates"
	spec.files = ["lib/certie.rb"]
	spec.require_paths = ["lib"]
	spec.executables=['certie']
	spec.add_dependency "openssl", "~> 2.2.0"
end
