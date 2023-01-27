require "application_system_test_case"

class RegistrosTest < ApplicationSystemTestCase
  setup do
    @registro = registros(:one)
  end

  test "visiting the index" do
    visit registros_url
    assert_selector "h1", text: "Registros"
  end

  test "creating a Registro" do
    visit registros_url
    click_on "New Registro"

    fill_in "Descuento", with: @registro.descuento
    fill_in "Detalle", with: @registro.detalle
    fill_in "Duracion.time", with: @registro.duracion.time
    fill_in "Estado", with: @registro.estado
    fill_in "Fecha", with: @registro.fecha
    fill_in "Nota", with: @registro.nota
    fill_in "Owner class", with: @registro.owner_class
    fill_in "Owner", with: @registro.owner_id
    fill_in "Razon descuento", with: @registro.razon_descuento
    fill_in "Tipo", with: @registro.tipo
    click_on "Create Registro"

    assert_text "Registro was successfully created"
    click_on "Back"
  end

  test "updating a Registro" do
    visit registros_url
    click_on "Edit", match: :first

    fill_in "Descuento", with: @registro.descuento
    fill_in "Detalle", with: @registro.detalle
    fill_in "Duracion.time", with: @registro.duracion.time
    fill_in "Estado", with: @registro.estado
    fill_in "Fecha", with: @registro.fecha
    fill_in "Nota", with: @registro.nota
    fill_in "Owner class", with: @registro.owner_class
    fill_in "Owner", with: @registro.owner_id
    fill_in "Razon descuento", with: @registro.razon_descuento
    fill_in "Tipo", with: @registro.tipo
    click_on "Update Registro"

    assert_text "Registro was successfully updated"
    click_on "Back"
  end

  test "destroying a Registro" do
    visit registros_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Registro was successfully destroyed"
  end
end
