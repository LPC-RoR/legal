require "application_system_test_case"

class ComRequerimientosTest < ApplicationSystemTestCase
  setup do
    @com_requerimiento = com_requerimientos(:one)
  end

  test "visiting the index" do
    visit com_requerimientos_url
    assert_selector "h1", text: "Com requerimientos"
  end

  test "should create com requerimiento" do
    visit com_requerimientos_url
    click_on "New com requerimiento"

    fill_in "Asesoria legal", with: @com_requerimiento.asesoria_legal
    check "Auditoria" if @com_requerimiento.auditoria
    check "Capacitacion" if @com_requerimiento.capacitacion
    check "Consultoria" if @com_requerimiento.consultoria
    check "Contacto comercial" if @com_requerimiento.contacto_comercial
    fill_in "Email", with: @com_requerimiento.email
    check "Externalizacion" if @com_requerimiento.externalizacion
    check "Laborsafe" if @com_requerimiento.laborsafe
    fill_in "Nombre", with: @com_requerimiento.nombre
    fill_in "Razon social", with: @com_requerimiento.razon_social
    check "Reunion telematica" if @com_requerimiento.reunion_telematica
    fill_in "Rut", with: @com_requerimiento.rut
    click_on "Create Com requerimiento"

    assert_text "Com requerimiento was successfully created"
    click_on "Back"
  end

  test "should update Com requerimiento" do
    visit com_requerimiento_url(@com_requerimiento)
    click_on "Edit this com requerimiento", match: :first

    fill_in "Asesoria legal", with: @com_requerimiento.asesoria_legal
    check "Auditoria" if @com_requerimiento.auditoria
    check "Capacitacion" if @com_requerimiento.capacitacion
    check "Consultoria" if @com_requerimiento.consultoria
    check "Contacto comercial" if @com_requerimiento.contacto_comercial
    fill_in "Email", with: @com_requerimiento.email
    check "Externalizacion" if @com_requerimiento.externalizacion
    check "Laborsafe" if @com_requerimiento.laborsafe
    fill_in "Nombre", with: @com_requerimiento.nombre
    fill_in "Razon social", with: @com_requerimiento.razon_social
    check "Reunion telematica" if @com_requerimiento.reunion_telematica
    fill_in "Rut", with: @com_requerimiento.rut
    click_on "Update Com requerimiento"

    assert_text "Com requerimiento was successfully updated"
    click_on "Back"
  end

  test "should destroy Com requerimiento" do
    visit com_requerimiento_url(@com_requerimiento)
    click_on "Destroy this com requerimiento", match: :first

    assert_text "Com requerimiento was successfully destroyed"
  end
end
