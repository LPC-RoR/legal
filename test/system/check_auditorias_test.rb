require "application_system_test_case"

class CheckAuditoriasTest < ApplicationSystemTestCase
  setup do
    @check_auditoria = check_auditorias(:one)
  end

  test "visiting the index" do
    visit check_auditorias_url
    assert_selector "h1", text: "Check auditorias"
  end

  test "should create check auditoria" do
    visit check_auditorias_url
    click_on "New check auditoria"

    fill_in "Audited at", with: @check_auditoria.audited_at
    fill_in "Cdg", with: @check_auditoria.cdg
    fill_in "Mdl", with: @check_auditoria.mdl
    fill_in "Ownr", with: @check_auditoria.ownr_id
    fill_in "Ownr type", with: @check_auditoria.ownr_type
    check "Prsnt" if @check_auditoria.prsnt
    click_on "Create Check auditoria"

    assert_text "Check auditoria was successfully created"
    click_on "Back"
  end

  test "should update Check auditoria" do
    visit check_auditoria_url(@check_auditoria)
    click_on "Edit this check auditoria", match: :first

    fill_in "Audited at", with: @check_auditoria.audited_at.to_s
    fill_in "Cdg", with: @check_auditoria.cdg
    fill_in "Mdl", with: @check_auditoria.mdl
    fill_in "Ownr", with: @check_auditoria.ownr_id
    fill_in "Ownr type", with: @check_auditoria.ownr_type
    check "Prsnt" if @check_auditoria.prsnt
    click_on "Update Check auditoria"

    assert_text "Check auditoria was successfully updated"
    click_on "Back"
  end

  test "should destroy Check auditoria" do
    visit check_auditoria_url(@check_auditoria)
    click_on "Destroy this check auditoria", match: :first

    assert_text "Check auditoria was successfully destroyed"
  end
end
