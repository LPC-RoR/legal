require "application_system_test_case"

class PreguntasTest < ApplicationSystemTestCase
  setup do
    @pregunta = preguntas(:one)
  end

  test "visiting the index" do
    visit preguntas_url
    assert_selector "h1", text: "Preguntas"
  end

  test "should create pregunta" do
    visit preguntas_url
    click_on "New pregunta"

    fill_in "Orden", with: @pregunta.orden
    fill_in "Pregunta", with: @pregunta.pregunta
    fill_in "Referencia", with: @pregunta.referencia
    fill_in "Tipo", with: @pregunta.tipo
    click_on "Create Pregunta"

    assert_text "Pregunta was successfully created"
    click_on "Back"
  end

  test "should update Pregunta" do
    visit pregunta_url(@pregunta)
    click_on "Edit this pregunta", match: :first

    fill_in "Orden", with: @pregunta.orden
    fill_in "Pregunta", with: @pregunta.pregunta
    fill_in "Referencia", with: @pregunta.referencia
    fill_in "Tipo", with: @pregunta.tipo
    click_on "Update Pregunta"

    assert_text "Pregunta was successfully updated"
    click_on "Back"
  end

  test "should destroy Pregunta" do
    visit pregunta_url(@pregunta)
    click_on "Destroy this pregunta", match: :first

    assert_text "Pregunta was successfully destroyed"
  end
end
