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
    click_button("Edit Message")
    fill_in "message", :with => "Yo Whats Up?"
    click_button("Update Message")
    expect(page).to have_content("Yo Whats Up?")
    expect(page).to_not have_content("Hello Everyone")

  end

  scenario "As a user, I can not update my message to text longer than 140 characters." do
    visit "/"
    fill_in "Message", :with => "Hello Everyone!"
    click_button "Submit"
    expect(page).to have_content("Hello Everyone!")
    click_button("Edit Message")
    fill_in "message", :with => "a" * 141
    click_button("Update Message")
    expect(page).to have_content("Message must be less than 140 characters.")

  end

  scenario "As a user, I can delete messages" do
  visit "/"
  fill_in "Message", :with => "Hello Everyone!"
  click_button "Submit"
  click_button "Delete"
  expect(page).to_not have_content("Hello Everyone!")
  end

  scenario "As a user, I can add comments" do
    visit "/"
    fill_in "Message", :with => "Hello Everyone!"
    click_button "Submit"
    expect(page).to have_content("Hello Everyone!")
    click_button("Add Comment")
    fill_in "comment", :with => "Hi to you too!"
    click_button("Add Comment")
    expect(page).to have_content("Hello Everyone!")
    expect(page).to have_content("Hi to you too!")

  end

  scenario "As a user, I can view a page for a message and it's comments" do
    visit "/"
    fill_in "Message", :with => "Hello Everyone!"
    click_button "Submit"
    expect(page).to have_content("Hello Everyone!")
    click_button("Add Comment")
    fill_in "comment", :with => "Hi to you too!"
    click_button("Add Comment")
    expect(page).to have_content("Hello Everyone!")
    expect(page).to have_content("Hi to you too!")
    click_link("Hello Everyone!")
    expect(page).to have_content("Hi to you too!")

  end
  end
