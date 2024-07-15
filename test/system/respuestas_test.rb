require "application_system_test_case"

class RespuestasTest < ApplicationSystemTestCase
  setup do
    @respuesta = respuestas(:one)
  end

  test "visiting the index" do
    visit respuestas_url
    assert_selector "h1", text: "Respuestas"
  end

  test "should create respuesta" do
    visit respuestas_url
    click_on "New respuesta"

    fill_in "Campania", with: @respuesta.campania_id
    fill_in "Propuesta", with: @respuesta.propuesta
    fill_in "Respuesta", with: @respuesta.respuesta
    fill_in "Sesion", with: @respuesta.sesion_id
    click_on "Create Respuesta"

    assert_text "Respuesta was successfully created"
    click_on "Back"
  end

  test "should update Respuesta" do
    visit respuesta_url(@respuesta)
    click_on "Edit this respuesta", match: :first

    fill_in "Campania", with: @respuesta.campania_id
    fill_in "Propuesta", with: @respuesta.propuesta
    fill_in "Respuesta", with: @respuesta.respuesta
    fill_in "Sesion", with: @respuesta.sesion_id
    click_on "Update Respuesta"

    assert_text "Respuesta was successfully updated"
    click_on "Back"
  end

  test "should destroy Respuesta" do
    visit respuesta_url(@respuesta)
    click_on "Destroy this respuesta", match: :first

    assert_text "Respuesta was successfully destroyed"
  end
end
