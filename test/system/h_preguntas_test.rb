require "application_system_test_case"

class HPreguntasTest < ApplicationSystemTestCase
  setup do
    @h_pregunta = h_preguntas(:one)
  end

  test "visiting the index" do
    visit h_preguntas_url
    assert_selector "h1", text: "H preguntas"
  end

  test "should create h pregunta" do
    visit h_preguntas_url
    click_on "New h pregunta"

    fill_in "H pregunta", with: @h_pregunta.h_pregunta
    fill_in "Lnk", with: @h_pregunta.lnk
    fill_in "Lnk txt", with: @h_pregunta.lnk_txt
    fill_in "Respuesta", with: @h_pregunta.respuesta
    click_on "Create H pregunta"

    assert_text "H pregunta was successfully created"
    click_on "Back"
  end

  test "should update H pregunta" do
    visit h_pregunta_url(@h_pregunta)
    click_on "Edit this h pregunta", match: :first

    fill_in "H pregunta", with: @h_pregunta.h_pregunta
    fill_in "Lnk", with: @h_pregunta.lnk
    fill_in "Lnk txt", with: @h_pregunta.lnk_txt
    fill_in "Respuesta", with: @h_pregunta.respuesta
    click_on "Update H pregunta"

    assert_text "H pregunta was successfully updated"
    click_on "Back"
  end

  test "should destroy H pregunta" do
    visit h_pregunta_url(@h_pregunta)
    click_on "Destroy this h pregunta", match: :first

    assert_text "H pregunta was successfully destroyed"
  end
end
