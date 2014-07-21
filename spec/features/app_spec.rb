require "rspec"
require "capybara"


feature "Messages" do
  scenario "As a user, I can submit a message" do
    visit "/"

    expect(page).to have_content("Message Roullete")

    fill_in "Message", :with => "Hello Everyone!"

    click_button "Submit"

    expect(page).to have_content("Hello Everyone!")
  end

  scenario "As a user, I see an error message if I enter a message > 140 characters" do
    visit "/"

    fill_in "Message", :with => "a" * 141

    click_button "Submit"

    expect(page).to have_content("Message must be less than 140 characters.")
  end

  scenario "As a user, I can update my message" do
    visit "/"
    fill_in "Message", :with => "Hello Everyone!"
    click_button "Submit"
    expect(page).to have_content("Hello Everyone!")
    click_link("Edit Message")
    fill_in "message", :with => "Yo Whats Up?"
    click_button("Update Message")
    save_and_open_page
    expect(page).to have_content("Yo Whats Up?")
    expect(page).to_not have_content("Hello Everyone")

  end
end
