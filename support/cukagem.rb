ENV["RAILS_ENV"] = "test"

module Cukigem
  mattr_accessor :project_root, :temp_root, :application_name
  
  self.project_root = File.expand_path(File.join(File.dirname(__FILE__), '..', '..')).freeze
  self.temp_root = File.join(project_root, "tmp").freeze
  self.application_name = "rails_app".freeze
  
  class << self
    def app_root
      File.join(temp_root, application_name)
    end
  end
end
