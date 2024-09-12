require "application_system_test_case"

class KrnTestigosTest < ApplicationSystemTestCase
  setup do
    @krn_testigo = krn_testigos(:one)
  end

  test "visiting the index" do
    visit krn_testigos_url
    assert_selector "h1", text: "Krn testigos"
  end

  test "should create krn testigo" do
    visit krn_testigos_url
    click_on "New krn testigo"

    fill_in "Cargo", with: @krn_testigo.cargo
    fill_in "Email", with: @krn_testigo.email
    check "Email ok" if @krn_testigo.email_ok
    check "Info derechos" if @krn_testigo.info_derechos
    check "Info procedimiento" if @krn_testigo.info_procedimiento
    check "Info reglamento" if @krn_testigo.info_reglamento
    fill_in "Krn empresa externa", with: @krn_testigo.krn_empresa_externa_id
    fill_in "Lugar trabajo", with: @krn_testigo.lugar_trabajo
    fill_in "Nombre", with: @krn_testigo.nombre
    fill_in "Ownr", with: @krn_testigo.ownr_id
    fill_in "Ownr type", with: @krn_testigo.ownr_type
    fill_in "Rut", with: @krn_testigo.rut
    click_on "Create Krn testigo"

    assert_text "Krn testigo was successfully created"
    click_on "Back"
  end

  test "should update Krn testigo" do
    visit krn_testigo_url(@krn_testigo)
    click_on "Edit this krn testigo", match: :first

    fill_in "Cargo", with: @krn_testigo.cargo
    fill_in "Email", with: @krn_testigo.email
    check "Email ok" if @krn_testigo.email_ok
    check "Info derechos" if @krn_testigo.info_derechos
    check "Info procedimiento" if @krn_testigo.info_procedimiento
    check "Info reglamento" if @krn_testigo.info_reglamento
    fill_in "Krn empresa externa", with: @krn_testigo.krn_empresa_externa_id
    fill_in "Lugar trabajo", with: @krn_testigo.lugar_trabajo
    fill_in "Nombre", with: @krn_testigo.nombre
    fill_in "Ownr", with: @krn_testigo.ownr_id
    fill_in "Ownr type", with: @krn_testigo.ownr_type
    fill_in "Rut", with: @krn_testigo.rut
    click_on "Update Krn testigo"

    assert_text "Krn testigo was successfully updated"
    click_on "Back"
  end

  test "should destroy Krn testigo" do
    visit krn_testigo_url(@krn_testigo)
    click_on "Destroy this krn testigo", match: :first

    assert_text "Krn testigo was successfully destroyed"
  end
end
