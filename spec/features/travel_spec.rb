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

    @form = first('.form')
    fill_form_and_search(@form)
  end

  # I've split this big test to 3 small only to show my skills.
  # In real I would prefer to have a big one for performance reason: right now it takes 8 seconds VS 3 seconds before.

  scenario 'it shows results from all 6 lines' do
    VCR.use_cassette 'find flight' do
      within @form do
        expect(page).to have_css('.results > div', count: 6)

        results = page.find('.results')

        expect(results).to have_css 'div.airline', text: 'Aeroflot'
        expect(results).to have_css 'div.airline', text: 'China Eastern'
        expect(results).to have_css 'div.airline', text: 'Emirates'
        expect(results).to have_css 'div.airline', text: 'Korean Air lines'
        expect(results).to have_css 'div.airline', text: 'Qantas'
        expect(results).to have_css 'div.airline', text: 'Singapore Airlines'
      end
    end
  end

  scenario 'it does not affect second form' do
    VCR.use_cassette 'find flight' do
      second_form = all('.form')[1]
      within second_form do
        expect(page.find('[name=from]').value).to be_blank
        expect(page.find('[name=to]').value).to be_blank
        expect(page.find('[name=date]').value).to be_blank
        expect(page).not_to have_css('.results > div')
      end
    end
  end

  scenario 'results contain our flight' do
    VCR.use_cassette 'find flight' do
      within @form do
        results = page.find('.results')

        results_su = results.find('.results-SU')
        expect(results_su).to have_css('.result', count: 9, wait: 15)

        flight = results_su.all('.result')[4]
        expect(flight).to have_content 'Adelaide Arpt in Adelaide'
        expect(flight).to have_content 'Balmaceda Arpt in Balmaceda'
        expect(flight).to have_content 'Plane: TU-95V'
        expect(flight).to have_content 'Aeroflot'
      end
    end
  end

  def fill_form_and_search(form)
    within form do
      fill_in 'from', with: 'de'
      choose_autocomplete_result 'Adelaide Arpt, Adelaide Australia'

      fill_in 'to', with: 'ed'
      choose_autocomplete_result 'Balmaceda Arpt, Balmaceda Chile'
    end

    form.find('[name=date]').trigger('focus').click()
    find('.ui-datepicker-calendar a', text: '22').click

    form.click_on 'Search'
  end
end
