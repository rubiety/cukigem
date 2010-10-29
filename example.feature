Feature: Micro Sessions
  
  Scenario: Transitioning Between Pages While Passing Micro Session ID
    Given I have a rails application
    And I save the following as "app/controllers/models_controller.rb":
    """
    class ModelsController < ApplicationController
      micro_sessions
      
      def index
        micro_session[:string] = "String"
      end
      
      def new
      end
    end
    """
    And I save the following as "app/views/models/index.html.erb":
    """
    <%= link_to "New", :action => :new, :micro_sessions => true %>
    """
    And I save the following as "app/views/models/new.html.erb":
    """
    <%= micro_session[:string] %>
    """
    And I start the rails application
    When I go to the models page
    And I follow "New"
    Then I should see "String"
  
  Scenario: Transitioning Between Pages Without Passing Micro Session ID
    Given I start the rails application
    When I go to the models page
    Then I should see "String"
    When I go to the models new page
    Then I should not see "String"
  