require "application_system_test_case"

class NotasTest < ApplicationSystemTestCase
  setup do
    @nota = notas(:one)
  end

  test "visiting the index" do
    visit notas_url
    assert_selector "h1", text: "Notas"
  end

  test "should create nota" do
    visit notas_url
    click_on "New nota"

    fill_in "Nota", with: @nota.nota
    fill_in "Ownr clss", with: @nota.ownr_clss
    fill_in "Ownr", with: @nota.ownr_id
    fill_in "Perfil", with: @nota.perfil_id
    fill_in "Prioridad", with: @nota.prioridad
    check "Realizado" if @nota.realizado
    click_on "Create Nota"

    assert_text "Nota was successfully created"
    click_on "Back"
  end

  test "should update Nota" do
    visit nota_url(@nota)
    click_on "Edit this nota", match: :first

    fill_in "Nota", with: @nota.nota
    fill_in "Ownr clss", with: @nota.ownr_clss
    fill_in "Ownr", with: @nota.ownr_id
    fill_in "Perfil", with: @nota.perfil_id
    fill_in "Prioridad", with: @nota.prioridad
    check "Realizado" if @nota.realizado
    click_on "Update Nota"

    assert_text "Nota was successfully updated"
    click_on "Back"
  end

  test "should destroy Nota" do
    visit nota_url(@nota)
    click_on "Destroy this nota", match: :first

    assert_text "Nota was successfully destroyed"
  end
end
