require "application_system_test_case"

class AppMsgMsgsTest < ApplicationSystemTestCase
  setup do
    @app_msg_msg = app_msg_msgs(:one)
  end

  test "visiting the index" do
    visit app_msg_msgs_url
    assert_selector "h1", text: "App Msg Msgs"
  end

  test "creating a App msg msg" do
    visit app_msg_msgs_url
    click_on "New App Msg Msg"

    fill_in "Child", with: @app_msg_msg.child_id
    fill_in "Parent", with: @app_msg_msg.parent_id
    click_on "Create App msg msg"

    assert_text "App msg msg was successfully created"
    click_on "Back"
  end

  test "updating a App msg msg" do
    visit app_msg_msgs_url
    click_on "Edit", match: :first

    fill_in "Child", with: @app_msg_msg.child_id
    fill_in "Parent", with: @app_msg_msg.parent_id
    click_on "Update App msg msg"

    assert_text "App msg msg was successfully updated"
    click_on "Back"
  end

  test "destroying a App msg msg" do
    visit app_msg_msgs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "App msg msg was successfully destroyed"
  end
end
