# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rails3-amf}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Stephen Augenstein"]
  s.date = %q{2010-09-23}
  s.email = %q{perl.programmer@gmail.com}
  s.files = ["README.rdoc", "Rakefile", "lib/rails3-amf/action_controller.rb", "lib/rails3-amf/configuration.rb", "lib/rails3-amf/intermediate_model.rb", "lib/rails3-amf/railtie.rb", "lib/rails3-amf/request_parser.rb", "lib/rails3-amf/request_processor.rb", "lib/rails3-amf/serialization.rb", "lib/rails3-amf.rb"]
  s.homepage = %q{http://github.com/warhammerkid/rails3-amf}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{A Rails 3 plugin that provides tight rails amf integration}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
