require "application_system_test_case"

class KrnEmpresaExternasTest < ApplicationSystemTestCase
  setup do
    @krn_empresa_externa = krn_empresa_externas(:one)
  end

  test "visiting the index" do
    visit krn_empresa_externas_url
    assert_selector "h1", text: "Krn empresa externas"
  end

  test "should create krn empresa externa" do
    visit krn_empresa_externas_url
    click_on "New krn empresa externa"

    fill_in "Contacto", with: @krn_empresa_externa.contacto
    fill_in "Email contacto", with: @krn_empresa_externa.email_contacto
    fill_in "Razon social", with: @krn_empresa_externa.razon_social
    fill_in "Rut", with: @krn_empresa_externa.rut
    fill_in "Tipo", with: @krn_empresa_externa.tipo
    click_on "Create Krn empresa externa"

    assert_text "Krn empresa externa was successfully created"
    click_on "Back"
  end

  test "should update Krn empresa externa" do
    visit krn_empresa_externa_url(@krn_empresa_externa)
    click_on "Edit this krn empresa externa", match: :first

    fill_in "Contacto", with: @krn_empresa_externa.contacto
    fill_in "Email contacto", with: @krn_empresa_externa.email_contacto
    fill_in "Razon social", with: @krn_empresa_externa.razon_social
    fill_in "Rut", with: @krn_empresa_externa.rut
    fill_in "Tipo", with: @krn_empresa_externa.tipo
    click_on "Update Krn empresa externa"

    assert_text "Krn empresa externa was successfully updated"
    click_on "Back"
  end

  test "should destroy Krn empresa externa" do
    visit krn_empresa_externa_url(@krn_empresa_externa)
    click_on "Destroy this krn empresa externa", match: :first

    assert_text "Krn empresa externa was successfully destroyed"
  end
end
