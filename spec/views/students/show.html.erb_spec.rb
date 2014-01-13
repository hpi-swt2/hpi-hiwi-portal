require 'spec_helper'

describe "students/show" do
  before(:each) do
    @user = assign(:user, stub_model(User,
      :firstname => "First Name",
      :lastname => "Last Name",
      :semester => 1,
      :academic_program => "Academic Program",
      :birthday => '2013-11-10',
      :education => "MyText",
      :additional_information => "MyText",
      :homepage => "Homepage",
      :github => "Github",
      :facebook => "Facebook",
      :xing => "Xing",
      :linkedin => "Linkedin"
    ))

    view.stub(:signed_in?) { false }
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/First Name/)
    rendered.should match(/Last Name/)
    rendered.should match(/1/)
    rendered.should match(/Academic Program/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/Homepage/)
    rendered.should match(/Github/)
    rendered.should match(/Facebook/)
    rendered.should match(/Xing/)
    rendered.should match(/Linkedin/)
  end
end
