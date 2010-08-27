require 'rubygems'
require 'rake'
require 'rake/rdoctask'
require 'rake/gempackagetask'

spec = Gem::Specification.new do |s|
  s.name    = 'rails3-amf'
  s.version = '0.1.0'
  s.summary = 'A Rails 3 plugin that provides tight rails amf integration'

  s.files        = FileList['README.rdoc', 'Rakefile', 'lib/**/*.rb']
  s.require_path = 'lib'

  s.authors  = ['Stephen Augenstein']
  s.email    = 'perl.programmer@gmail.com'
  s.homepage = 'http://github.com/warhammerkid/rails3-amf'

  s.platform = Gem::Platform::RUBY
end

Rake::GemPackageTask.new spec do |pkg|
  pkg.need_tar = true
  pkg.need_zip = true
end

desc 'Generate a gemspec file'
task :gemspec do
  File.open("#{spec.name}.gemspec", 'w') do |f|
    f.write spec.to_ruby
  end
end