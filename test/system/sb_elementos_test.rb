require "application_system_test_case"

class SbElementosTest < ApplicationSystemTestCase
  setup do
    @sb_elemento = sb_elementos(:one)
  end

  test "visiting the index" do
    visit sb_elementos_url
    assert_selector "h1", text: "Sb Elementos"
  end

  test "creating a Sb elemento" do
    visit sb_elementos_url
    click_on "New Sb Elemento"

    fill_in "Acceso", with: @sb_elemento.acceso
    check "Activo" if @sb_elemento.activo
    fill_in "Controlador", with: @sb_elemento.controlador
    fill_in "Despliegue", with: @sb_elemento.despliegue
    fill_in "Elemento", with: @sb_elemento.elemento
    fill_in "Nivel", with: @sb_elemento.nivel
    fill_in "Orden", with: @sb_elemento.orden
    fill_in "Sb lista", with: @sb_elemento.sb_lista_id
    fill_in "Tipo", with: @sb_elemento.tipo
    click_on "Create Sb elemento"

    assert_text "Sb elemento was successfully created"
    click_on "Back"
  end

  test "updating a Sb elemento" do
    visit sb_elementos_url
    click_on "Edit", match: :first

    fill_in "Acceso", with: @sb_elemento.acceso
    check "Activo" if @sb_elemento.activo
    fill_in "Controlador", with: @sb_elemento.controlador
    fill_in "Despliegue", with: @sb_elemento.despliegue
    fill_in "Elemento", with: @sb_elemento.elemento
    fill_in "Nivel", with: @sb_elemento.nivel
    fill_in "Orden", with: @sb_elemento.orden
    fill_in "Sb lista", with: @sb_elemento.sb_lista_id
    fill_in "Tipo", with: @sb_elemento.tipo
    click_on "Update Sb elemento"

    assert_text "Sb elemento was successfully updated"
    click_on "Back"
  end

  test "destroying a Sb elemento" do
    visit sb_elementos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Sb elemento was successfully destroyed"
  end
end
