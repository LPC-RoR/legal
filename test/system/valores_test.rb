require "application_system_test_case"

class ValoresTest < ApplicationSystemTestCase
  setup do
    @valor = valores(:one)
  end

  test "visiting the index" do
    visit valores_url
    assert_selector "h1", text: "Valores"
  end

  test "creating a Valor" do
    visit valores_url
    click_on "New Valor"

    fill_in "C fecha", with: @valor.c_fecha
    fill_in "C numero", with: @valor.c_numero
    fill_in "C string", with: @valor.c_string
    fill_in "C text", with: @valor.c_text
    fill_in "Owner class", with: @valor.owner_class
    fill_in "Owner", with: @valor.owner_id
    fill_in "Variable", with: @valor.variable_id
    click_on "Create Valor"

    assert_text "Valor was successfully created"
    click_on "Back"
  end

  test "updating a Valor" do
    visit valores_url
    click_on "Edit", match: :first

    fill_in "C fecha", with: @valor.c_fecha
    fill_in "C numero", with: @valor.c_numero
    fill_in "C string", with: @valor.c_string
    fill_in "C text", with: @valor.c_text
    fill_in "Owner class", with: @valor.owner_class
    fill_in "Owner", with: @valor.owner_id
    fill_in "Variable", with: @valor.variable_id
    click_on "Update Valor"

    assert_text "Valor was successfully updated"
    click_on "Back"
  end

  test "destroying a Valor" do
    visit valores_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Valor was successfully destroyed"
  end
end
