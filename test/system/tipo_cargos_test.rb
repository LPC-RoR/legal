require "application_system_test_case"

class TipoCargosTest < ApplicationSystemTestCase
  setup do
    @tipo_cargo = tipo_cargos(:one)
  end

  test "visiting the index" do
    visit tipo_cargos_url
    assert_selector "h1", text: "Tipo Cargos"
  end

  test "creating a Tipo cargo" do
    visit tipo_cargos_url
    click_on "New Tipo Cargo"

    fill_in "Tipo cargo", with: @tipo_cargo.tipo_cargo
    click_on "Create Tipo cargo"

    assert_text "Tipo cargo was successfully created"
    click_on "Back"
  end

  test "updating a Tipo cargo" do
    visit tipo_cargos_url
    click_on "Edit", match: :first

    fill_in "Tipo cargo", with: @tipo_cargo.tipo_cargo
    click_on "Update Tipo cargo"

    assert_text "Tipo cargo was successfully updated"
    click_on "Back"
  end

  test "destroying a Tipo cargo" do
    visit tipo_cargos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tipo cargo was successfully destroyed"
  end
end
