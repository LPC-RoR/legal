require "application_system_test_case"

class OrgCargosTest < ApplicationSystemTestCase
  setup do
    @org_cargo = org_cargos(:one)
  end

  test "visiting the index" do
    visit org_cargos_url
    assert_selector "h1", text: "Org Cargos"
  end

  test "creating a Org cargo" do
    visit org_cargos_url
    click_on "New Org Cargo"

    fill_in "Dotacion", with: @org_cargo.dotacion
    fill_in "Org area", with: @org_cargo.org_area_id
    fill_in "Org cargo", with: @org_cargo.org_cargo
    click_on "Create Org cargo"

    assert_text "Org cargo was successfully created"
    click_on "Back"
  end

  test "updating a Org cargo" do
    visit org_cargos_url
    click_on "Edit", match: :first

    fill_in "Dotacion", with: @org_cargo.dotacion
    fill_in "Org area", with: @org_cargo.org_area_id
    fill_in "Org cargo", with: @org_cargo.org_cargo
    click_on "Update Org cargo"

    assert_text "Org cargo was successfully updated"
    click_on "Back"
  end

  test "destroying a Org cargo" do
    visit org_cargos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Org cargo was successfully destroyed"
  end
end
