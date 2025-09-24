require "application_system_test_case"

class CheckRealizadosTest < ApplicationSystemTestCase
  setup do
    @check_realizado = check_realizados(:one)
  end

  test "visiting the index" do
    visit check_realizados_url
    assert_selector "h1", text: "Check realizados"
  end

  test "should create check realizado" do
    visit check_realizados_url
    click_on "New check realizado"

    fill_in "App perfil", with: @check_realizado.app_perfil_id
    fill_in "Cdg", with: @check_realizado.cdg
    fill_in "Chequed at", with: @check_realizado.chequed_at
    fill_in "Mdl", with: @check_realizado.mdl
    fill_in "Ownr", with: @check_realizado.ownr_id
    fill_in "Ownr type", with: @check_realizado.ownr_type
    check "Rlzd" if @check_realizado.rlzd
    click_on "Create Check realizado"

    assert_text "Check realizado was successfully created"
    click_on "Back"
  end

  test "should update Check realizado" do
    visit check_realizado_url(@check_realizado)
    click_on "Edit this check realizado", match: :first

    fill_in "App perfil", with: @check_realizado.app_perfil_id
    fill_in "Cdg", with: @check_realizado.cdg
    fill_in "Chequed at", with: @check_realizado.chequed_at.to_s
    fill_in "Mdl", with: @check_realizado.mdl
    fill_in "Ownr", with: @check_realizado.ownr_id
    fill_in "Ownr type", with: @check_realizado.ownr_type
    check "Rlzd" if @check_realizado.rlzd
    click_on "Update Check realizado"

    assert_text "Check realizado was successfully updated"
    click_on "Back"
  end

  test "should destroy Check realizado" do
    visit check_realizado_url(@check_realizado)
    click_on "Destroy this check realizado", match: :first

    assert_text "Check realizado was successfully destroyed"
  end
end
