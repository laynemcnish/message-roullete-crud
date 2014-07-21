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
    click_button("Edit Message")
    fill_in "Message", :with => "Yo What's Up?"
    click_button("Update Message")
    expect(page).to have_content("Yo What's Up?")
    expact(page).to_not have_content("Hello Everyone")

  end
end
