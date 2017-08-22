# frozen_string_literal: true

require 'rails_helper'

feature 'Travel', :js do
  before do
    Timecop.travel '22.08.2017'
  end

  after do
    Timecop.return
  end

  background do
    visit root_path
  end

  scenario 'search for flight from "Adelaide Arpt, Adelaide Australia" to "Balmaceda Arpt, Balmaceda Chile" on 22.08.2017' do
    VCR.use_cassette 'find flight' do
      form = first('.form')
      within form do
        fill_in 'from', with: 'de'
        choose_autocomplete_result 'Adelaide Arpt, Adelaide Australia'

        fill_in 'to', with: 'ed'
        choose_autocomplete_result 'Balmaceda Arpt, Balmaceda Chile'
      end

      form.find('[name=date]').trigger('focus').click()
      find('.ui-datepicker-calendar a', text: '22').click

      form.click_on 'Search'

      within form do
        expect(page).to have_css('.results > div', count: 6)

        results = page.find('.results')
        results_su = results.find('.results-SU')
        expect(results_su).to have_css('.result', count: 9, wait: 15)

        flight = results_su.all('.result')[4]
        expect(flight).to have_content 'Adelaide Arpt in Adelaide'
        expect(flight).to have_content 'Balmaceda Arpt in Balmaceda'
        expect(flight).to have_content 'Plane: TU-95V'
        expect(flight).to have_content 'Aeroflot'
      end

      second_form = all('.form')[1]
      within second_form do
        expect(page.find('[name=from]').value).to be_blank
        expect(page.find('[name=to]').value).to be_blank
        expect(page.find('[name=date]').value).to be_blank
        expect(page).not_to have_css('.results > div')
      end
    end
  end
end
