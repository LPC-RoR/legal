require "application_system_test_case"

class CfgValoresTest < ApplicationSystemTestCase
  setup do
    @cfg_valor = cfg_valores(:one)
  end

  test "visiting the index" do
    visit cfg_valores_url
    assert_selector "h1", text: "Cfg Valores"
  end

  test "creating a Cfg valor" do
    visit cfg_valores_url
    click_on "New Cfg Valor"

    fill_in "App version", with: @cfg_valor.app_version_id
    fill_in "Cfg valor", with: @cfg_valor.cfg_valor
    check "Check box" if @cfg_valor.check_box
    fill_in "Fecha", with: @cfg_valor.fecha
    fill_in "Fecha hora", with: @cfg_valor.fecha_hora
    fill_in "Numero", with: @cfg_valor.numero
    fill_in "Palabra", with: @cfg_valor.palabra
    fill_in "Texto", with: @cfg_valor.texto
    fill_in "Tipo", with: @cfg_valor.tipo
    click_on "Create Cfg valor"

    assert_text "Cfg valor was successfully created"
    click_on "Back"
  end

  test "updating a Cfg valor" do
    visit cfg_valores_url
    click_on "Edit", match: :first

    fill_in "App version", with: @cfg_valor.app_version_id
    fill_in "Cfg valor", with: @cfg_valor.cfg_valor
    check "Check box" if @cfg_valor.check_box
    fill_in "Fecha", with: @cfg_valor.fecha
    fill_in "Fecha hora", with: @cfg_valor.fecha_hora
    fill_in "Numero", with: @cfg_valor.numero
    fill_in "Palabra", with: @cfg_valor.palabra
    fill_in "Texto", with: @cfg_valor.texto
    fill_in "Tipo", with: @cfg_valor.tipo
    click_on "Update Cfg valor"

    assert_text "Cfg valor was successfully updated"
    click_on "Back"
  end

  test "destroying a Cfg valor" do
    visit cfg_valores_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Cfg valor was successfully destroyed"
  end
end
