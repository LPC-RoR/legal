require "application_system_test_case"

class AsesoriasTest < ApplicationSystemTestCase
  setup do
    @asesoria = asesorias(:one)
  end

  test "visiting the index" do
    visit asesorias_url
    assert_selector "h1", text: "Asesorias"
  end

  test "creating a Asesoria" do
    visit asesorias_url
    click_on "New Asesoria"

    fill_in "Cliente", with: @asesoria.cliente_id
    fill_in "Descripcion", with: @asesoria.descripcion
    fill_in "Detalle", with: @asesoria.detalle
    fill_in "Fecha", with: @asesoria.fecha
    fill_in "Plazo", with: @asesoria.plazo
    fill_in "Tar servicio", with: @asesoria.tar_servicio_id
    click_on "Create Asesoria"

    assert_text "Asesoria was successfully created"
    click_on "Back"
  end

  test "updating a Asesoria" do
    visit asesorias_url
    click_on "Edit", match: :first

    fill_in "Cliente", with: @asesoria.cliente_id
    fill_in "Descripcion", with: @asesoria.descripcion
    fill_in "Detalle", with: @asesoria.detalle
    fill_in "Fecha", with: @asesoria.fecha
    fill_in "Plazo", with: @asesoria.plazo
    fill_in "Tar servicio", with: @asesoria.tar_servicio_id
    click_on "Update Asesoria"

    assert_text "Asesoria was successfully updated"
    click_on "Back"
  end

  test "destroying a Asesoria" do
    visit asesorias_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Asesoria was successfully destroyed"
  end
end
