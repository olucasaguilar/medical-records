require 'spec_helper'

describe 'User view homepage', js: true do
  it "successfully" do
    visit '/'

    expect(page).to have_content "Exames médicos"
  end
end