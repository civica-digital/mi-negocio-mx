require 'rails_helper'

feature 'A business enters the inspections view' do
  attr_reader :municipio, :user

  before do
    @municipio = create :municipio
    @user = create :user
  end

  scenario 'and creates a new complaint without a user login' do
    visit municipio_inspections_path(municipio)
    click_on I18n.t('inspections.index.complaint')

    # should redirect us to the users controller view and tell us
    # that we need to login, so that we can post a new complaint
    expect(page).to have_content I18n.t('devise.sessions.user.session_needed_to_continue')
    expect(current_path).to eq new_user_path
  end

  scenario 'and creates a new complaint with a user login' do
    # sign in user
    sign_in(user)

    # go to the city new complaint section
    visit new_municipio_complaint_path(municipio)

    choose(COMPLAINTS['regulation_violation'])
    click_on I18n.t('complaints.new.save_button')
  end
end
