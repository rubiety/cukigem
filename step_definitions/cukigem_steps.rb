Given %r{^I have a rails application$} do
  Given %{I generate a rails application}
  And %{the Gemfile is configured for testing}
  And %{the Gemfile contains this gem}
  And %{I run "bundle install"}
end

Given %r{^I ensure a rails application is generated$} do
  unless File.exists?(Cukigem.project_root)
    Given "I generate a rails application"
  end
end

Given %r{^I generate a rails application$} do
  FileUtils.rm_rf(Cukigem.temp_root)
  FileUtils.mkdir_p(Cukigem.temp_root)
  
  Dir.chdir(Cukigem.temp_root) do
    `rails new #{Cukigem.application_name}`
  end
end

When %r{^the Gemfile is configured for testing$} do
  When %{I append the following to "Gemfile"}, %{
    group :test do
      gem "capybara"
      gem "rspec"
    end
  }
end

When %r{^the Gemfile contains this gem$} do
  When %{I append the following to "Gemfile"}, %{gem "#{File.basename(Cukigem.project_root)}", :path => "#{Cukigem.project_root}"}
end

When %r{^I setup the database$} do
  When %{I run "bundle exec rake db:create db:migrate --trace"}
end


When %r{^I start the rails application$} do
  Dir.chdir(Cukigem.app_root) do
    require "config/environment"
    
    if Object.const_defined?(Capybara)
      require "capybara/rails"
    elsif Object.const_defined?(Webrat)
      require "webrat/rails"
    end
  end
end

When %r{^I save the following as "([^"]*)"} do |path, string|
  FileUtils.mkdir_p(File.join(Cukigem.app_root, File.dirname(path)))
  File.open(File.join(Cukigem.app_root, path), "w") do |file|
    file.write(string)
  end
end

When %r{^I append the following to "([^"]*)"} do |path, string|
  FileUtils.mkdir_p(File.join(Cukigem.app_root, File.dirname(path)))
  File.open(File.join(Cukigem.app_root, path), "a+") do |file|
    file.write(string)
  end
end

When %r{^I run "([^"]*)"$} do |command|
  Dir.chdir(Cukigem.app_root) do
    `#{command}`
  end
end

Then %r{^the file "([^"]*)" should exist$} do |file|
  File.should be_exist(File.join(Cukigem.app_root, file))
end
