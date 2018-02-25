require 'rails_helper'

feature 'Update languages' do
  describe 'with Poltergeist' do
    background do
      Capybara.current_driver = :poltergeist
      page.driver.resize(1024, 4000)
      @location = create(:location)
      login_super_admin
      visit '/admin/locations/vrs-services'
    end

    scenario 'with one language', :js do
      select2('French', 'location_languages', multiple: true)
      click_button I18n.t('admin.buttons.save_changes')
      expect(@location.reload.languages).to eq ['French']
    end

    scenario 'with two languages', :js do
      select2('French', 'location_languages', multiple: true)
      select2('Spanish', 'location_languages', multiple: true)
      click_button I18n.t('admin.buttons.save_changes')
      expect(@location.reload.languages).to eq %w(French Spanish)
    end

    scenario 'removing a language', :js do
      @location.update!(languages: %w(Arabic French))
      visit '/admin/locations/vrs-services'
      first('.select2-search-choice-close').click
      click_button I18n.t('admin.buttons.save_changes')
      expect(@location.reload.languages).to eq ['French']
    end
  end

  describe 'with Rack::Test' do
    background do
      @location = create(:location)
      login_super_admin
      visit '/admin/locations/vrs-services'
    end

    scenario 'with no languages' do
      click_button I18n.t('admin.buttons.save_changes')
      expect(@location.reload.languages).to eq []
    end
  end
end
