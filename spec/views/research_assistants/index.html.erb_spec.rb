require 'spec_helper'

describe "research_assistants/index" do
  before(:each) do
    assign(:users, [
      stub_model(User,
        :firstname => "First Name",
        :lastname => "Last Name",
        :birthday => '2013-11-10',
        :additional_information => "MyAdditionalInformation",
        :homepage => "Homepage",
        :github => "Github",
        :facebook => "Facebook",
        :xing => "Xing",
        :linkedin => "Linkedin",
      ),
      stub_model(User,
        :firstname => "First Name",
        :lastname => "Last Name",
        :birthday => '2013-11-10',
        :additional_information => "MyAdditionalInformation",
        :homepage => "Homepage",
        :github => "Github",
        :facebook => "Facebook",
        :xing => "Xing",
        :linkedin => "Linkedin",
      )
    ])
  end

  it "renders a list of students" do
    view.stub(:will_paginate)
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "a", :text => "First Name Last Name", :count => 2
  end
end
