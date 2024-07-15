require "application_system_test_case"

class HmLinksTest < ApplicationSystemTestCase
  setup do
    @hm_link = hm_links(:one)
  end

  test "visiting the index" do
    visit hm_links_url
    assert_selector "h1", text: "Hm links"
  end

  test "should create hm link" do
    visit hm_links_url
    click_on "New hm link"

    fill_in "Hm link", with: @hm_link.hm_link
    fill_in "Hm parrafo", with: @hm_link.hm_parrafo_id
    fill_in "Orden", with: @hm_link.orden
    fill_in "Texto", with: @hm_link.texto
    click_on "Create Hm link"

    assert_text "Hm link was successfully created"
    click_on "Back"
  end

  test "should update Hm link" do
    visit hm_link_url(@hm_link)
    click_on "Edit this hm link", match: :first

    fill_in "Hm link", with: @hm_link.hm_link
    fill_in "Hm parrafo", with: @hm_link.hm_parrafo_id
    fill_in "Orden", with: @hm_link.orden
    fill_in "Texto", with: @hm_link.texto
    click_on "Update Hm link"

    assert_text "Hm link was successfully updated"
    click_on "Back"
  end

  test "should destroy Hm link" do
    visit hm_link_url(@hm_link)
    click_on "Destroy this hm link", match: :first

    assert_text "Hm link was successfully destroyed"
  end
end
