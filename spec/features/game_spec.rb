require 'rails_helper'

RSpec.feature 'User starts a game' do
  before(:each) do
    visit root_path
  end

  scenario 'they see the panhandle action' do
    expect(page).to have_link('Panhandle for one hour')
  end

  scenario 'they see the rummage action' do
    expect(page).to have_link('Rummage for one hour')
  end
end
