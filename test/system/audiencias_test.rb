require "application_system_test_case"

class AudienciasTest < ApplicationSystemTestCase
  setup do
    @audiencia = audiencias(:one)
  end

  test "visiting the index" do
    visit audiencias_url
    assert_selector "h1", text: "Audiencias"
  end

  test "creating a Audiencia" do
    visit audiencias_url
    click_on "New Audiencia"

    fill_in "Audiencia", with: @audiencia.audiencia
    fill_in "Tipo", with: @audiencia.tipo
    fill_in "Tipo causa", with: @audiencia.tipo_causa_id
    click_on "Create Audiencia"

    assert_text "Audiencia was successfully created"
    click_on "Back"
  end

  test "updating a Audiencia" do
    visit audiencias_url
    click_on "Edit", match: :first

    fill_in "Audiencia", with: @audiencia.audiencia
    fill_in "Tipo", with: @audiencia.tipo
    fill_in "Tipo causa", with: @audiencia.tipo_causa_id
    click_on "Update Audiencia"

    assert_text "Audiencia was successfully updated"
    click_on "Back"
  end

  test "destroying a Audiencia" do
    visit audiencias_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Audiencia was successfully destroyed"
  end
end
