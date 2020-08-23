Gem::Specification.new do |spec|
	spec.authors = ["Katkam Nitin Reddy"]
	spec.name = "certie"
	spec.version = "0.0.3"
	spec.date = '2020-08-22'
  spec.summary = "A utility for generating certificates"
	spec.files = ["lib/certie.rb"]
	spec.require_paths = ["lib"]
	spec.executables=['certie']
	spec.add_dependency "openssl" #, "~> 0.0"
end
