require "application_system_test_case"

class TipoAsesoriasTest < ApplicationSystemTestCase
  setup do
    @tipo_asesoria = tipo_asesorias(:one)
  end

  test "visiting the index" do
    visit tipo_asesorias_url
    assert_selector "h1", text: "Tipo Asesorias"
  end

  test "creating a Tipo asesoria" do
    visit tipo_asesorias_url
    click_on "New Tipo Asesoria"

    check "Archivos" if @tipo_asesoria.archivos
    check "Documento" if @tipo_asesoria.documento
    check "Facturable" if @tipo_asesoria.facturable
    fill_in "Tipo asesoria", with: @tipo_asesoria.tipo_asesoria
    click_on "Create Tipo asesoria"

    assert_text "Tipo asesoria was successfully created"
    click_on "Back"
  end

  test "updating a Tipo asesoria" do
    visit tipo_asesorias_url
    click_on "Edit", match: :first

    check "Archivos" if @tipo_asesoria.archivos
    check "Documento" if @tipo_asesoria.documento
    check "Facturable" if @tipo_asesoria.facturable
    fill_in "Tipo asesoria", with: @tipo_asesoria.tipo_asesoria
    click_on "Update Tipo asesoria"

    assert_text "Tipo asesoria was successfully updated"
    click_on "Back"
  end

  test "destroying a Tipo asesoria" do
    visit tipo_asesorias_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tipo asesoria was successfully destroyed"
  end
end
