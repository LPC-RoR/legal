require "application_system_test_case"

class AuditNotasTest < ApplicationSystemTestCase
  setup do
    @audit_nota = audit_notas(:one)
  end

  test "visiting the index" do
    visit audit_notas_url
    assert_selector "h1", text: "Audit notas"
  end

  test "should create audit nota" do
    visit audit_notas_url
    click_on "New audit nota"

    fill_in "App pefil", with: @audit_nota.app_pefil_id
    fill_in "Nota", with: @audit_nota.nota
    fill_in "Ownr", with: @audit_nota.ownr_id
    fill_in "Ownr type", with: @audit_nota.ownr_type
    fill_in "Prioridad", with: @audit_nota.prioridad
    fill_in "Recomendacion", with: @audit_nota.recomendacion
    click_on "Create Audit nota"

    assert_text "Audit nota was successfully created"
    click_on "Back"
  end

  test "should update Audit nota" do
    visit audit_nota_url(@audit_nota)
    click_on "Edit this audit nota", match: :first

    fill_in "App pefil", with: @audit_nota.app_pefil_id
    fill_in "Nota", with: @audit_nota.nota
    fill_in "Ownr", with: @audit_nota.ownr_id
    fill_in "Ownr type", with: @audit_nota.ownr_type
    fill_in "Prioridad", with: @audit_nota.prioridad
    fill_in "Recomendacion", with: @audit_nota.recomendacion
    click_on "Update Audit nota"

    assert_text "Audit nota was successfully updated"
    click_on "Back"
  end

  test "should destroy Audit nota" do
    visit audit_nota_url(@audit_nota)
    click_on "Destroy this audit nota", match: :first

    assert_text "Audit nota was successfully destroyed"
  end
end
