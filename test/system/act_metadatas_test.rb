require "application_system_test_case"

class ActMetadatasTest < ApplicationSystemTestCase
  setup do
    @act_metadata = act_metadatas(:one)
  end

  test "visiting the index" do
    visit act_metadatas_url
    assert_selector "h1", text: "Act metadatas"
  end

  test "should create act metadata" do
    visit act_metadatas_url
    click_on "New act metadata"

    fill_in "Act metadata", with: @act_metadata.act_metadata
    click_on "Create Act metadata"

    assert_text "Act metadata was successfully created"
    click_on "Back"
  end

  test "should update Act metadata" do
    visit act_metadata_url(@act_metadata)
    click_on "Edit this act metadata", match: :first

    fill_in "Act metadata", with: @act_metadata.act_metadata
    click_on "Update Act metadata"

    assert_text "Act metadata was successfully updated"
    click_on "Back"
  end

  test "should destroy Act metadata" do
    visit act_metadata_url(@act_metadata)
    click_on "Destroy this act metadata", match: :first

    assert_text "Act metadata was successfully destroyed"
  end
end
