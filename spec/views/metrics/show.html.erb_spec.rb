require 'spec_helper'

describe "metrics/show" do
  before(:each) do
    @metric = assign(:metric, stub_model(Metric,
      :title => "Title",
      :description => "Description"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    rendered.should match(/Description/)
  end
end
