require 'spec_helper'

describe :routes do

  describe "GET /st/optional_lessons/new" do
    it do
      get("/st/optional_lessons/new").should route_to(controller:"st/optional_lessons", action:"new")
    end
  end
  
end