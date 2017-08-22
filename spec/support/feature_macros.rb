module FeatureMacros
  def choose_autocomplete_result(text, input_id = 'input[data-autocomplete]')
    page.execute_script %{ $('#{input_id}').trigger("focus") }
    page.execute_script %{ $('#{input_id}').trigger("keydown") }
    sleep 1
    page.execute_script %{
      $('.ui-menu-item:contains("#{text}")').trigger("mouseenter").trigger("click");
    }
  end

  # rubocop:disable Metrics/AbcSize
  def screenshot
    unless RSpec.current_example.metadata[:js]
      raise ArgumentError, 'screenshot can only be used in JavaScript feature specs'
    end
    name = Time.zone.now.strftime('%Y-%m-%d-%H-%M-%S-%L')
    path = Rails.root.join(Capybara.save_path, "#{name}.png")
    html = Rails.root.join(Capybara.save_path, "#{name}.html")
    page.save_screenshot(path)
    File.open(html, 'w') { |f| f.write page.html }
    puts "Screenshot saved as #{path}"
    # Launchy.open(path.to_s)
  end
  # rubocop:enable Metrics/AbcSize
end

RSpec.configure do |config|
  config.include FeatureMacros
end
