require "application_system_test_case"

class EmpresasTest < ApplicationSystemTestCase
  setup do
    @empresa = empresas(:one)
  end

  test "visiting the index" do
    visit empresas_url
    assert_selector "h1", text: "Empresas"
  end

  test "should create empresa" do
    visit empresas_url
    click_on "New empresa"

    fill_in "Email administrador", with: @empresa.email_administrador
    fill_in "Email verificado", with: @empresa.email_verificado
    fill_in "Razon social", with: @empresa.razon_social
    fill_in "Rut", with: @empresa.rut
    fill_in "Sha1", with: @empresa.sha1
    click_on "Create Empresa"

    assert_text "Empresa was successfully created"
    click_on "Back"
  end

  test "should update Empresa" do
    visit empresa_url(@empresa)
    click_on "Edit this empresa", match: :first

    fill_in "Email administrador", with: @empresa.email_administrador
    fill_in "Email verificado", with: @empresa.email_verificado
    fill_in "Razon social", with: @empresa.razon_social
    fill_in "Rut", with: @empresa.rut
    fill_in "Sha1", with: @empresa.sha1
    click_on "Update Empresa"

    assert_text "Empresa was successfully updated"
    click_on "Back"
  end

  test "should destroy Empresa" do
    visit empresa_url(@empresa)
    click_on "Destroy this empresa", match: :first

    assert_text "Empresa was successfully destroyed"
  end
end
