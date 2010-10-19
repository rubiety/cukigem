Given %r{I have a rails application} do
  Given %{I generate a rails application}
  And %{this gem is available in the Gemfile}
  And %{I run "bundle install}
end

Given %r{I generate a rails application} do
  FileUtils.rm_rf(Cukagem.temp_root)
  FileUtils.mkdir_p(Cukagem.temp_root)
  
  Dir.chdir(Cukagem.temp_root) do
    `rails new #{Cukagem.application_name}`
  end
end

When %r{this gem is available in the Gemfile} do
  When %{I append the following to "Gemfile"}, %{gem "message_block", :path => "#{PROJECT_ROOT}"}
end

When %r{I setup the database for the rails application} do
  When %{I run "bundle exec rake db:create db:migrate --trace"}
end

When %r{the rails application is running} do
  Dir.chdir(Cukagem.app_root) do
    require "config/environment"
    
    if Object.const_defined?(Capybara)
      require "capybara/rails"
    elsif Object.const_defined?(Webrat)
      require "webrat/rails"
    end
  end
end

When %r{I save the following as "([^"]*)" in the rails application} do |path, string|
  FileUtils.mkdir_p(File.join(Cukagem.app_root, File.dirname(path)))
  File.open(File.join(Cukagem.app_root, path), "w") do |file|
    file.write(string)
  end
end

When %r{I append the following to "([^"]*)" in the rails application} do |path, string|
  FileUtils.mkdir_p(File.join(Cukagem.app_root, File.dirname(path)))
  File.open(File.join(Cukagem.app_root, path), "a+") do |file|
    file.write(string)
  end
end

When %r{I run "([^"]*)" in the rails application} do |command|
  Dir.chdir(CUC_RAILS_ROOT) do
    `#{command}`
  end
end

Then %r{^the file "([^"]*)" should exist in the rails application} do |file|
  File.should be_exist(File.join(Cukagem.app_root, file))
end
