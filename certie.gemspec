Gem::Specification.new do |spec|
	spec.authors = ["Katkam Nitin Reddy"]
	spec.name = "certie"
	spec.version = "0.0.7"
	spec.date = '2022-07-04'
  spec.summary = "A utility for generating certificates"
	spec.files = ["lib/certie.rb"]
	spec.require_paths = ["lib"]
	spec.executables=['certie']
	spec.add_dependency "openssl", "~> 2.2.0"
end
