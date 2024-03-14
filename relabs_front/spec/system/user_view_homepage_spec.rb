require 'spec_helper'

feature "User visit homepage" do
  scenario "Successfully" do
    visit('/')
    expect(page).to have_content("Exames médicos")
  end
end