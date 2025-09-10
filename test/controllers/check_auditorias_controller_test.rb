require "test_helper"

class CheckAuditoriasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @check_auditoria = check_auditorias(:one)
  end

  test "should get index" do
    get check_auditorias_url
    assert_response :success
  end

  test "should get new" do
    get new_check_auditoria_url
    assert_response :success
  end

  test "should create check_auditoria" do
    assert_difference("CheckAuditoria.count") do
      post check_auditorias_url, params: { check_auditoria: { audited_at: @check_auditoria.audited_at, cdg: @check_auditoria.cdg, mdl: @check_auditoria.mdl, ownr_id: @check_auditoria.ownr_id, ownr_type: @check_auditoria.ownr_type, prsnt: @check_auditoria.prsnt } }
    end

    assert_redirected_to check_auditoria_url(CheckAuditoria.last)
  end

  test "should show check_auditoria" do
    get check_auditoria_url(@check_auditoria)
    assert_response :success
  end

  test "should get edit" do
    get edit_check_auditoria_url(@check_auditoria)
    assert_response :success
  end

  test "should update check_auditoria" do
    patch check_auditoria_url(@check_auditoria), params: { check_auditoria: { audited_at: @check_auditoria.audited_at, cdg: @check_auditoria.cdg, mdl: @check_auditoria.mdl, ownr_id: @check_auditoria.ownr_id, ownr_type: @check_auditoria.ownr_type, prsnt: @check_auditoria.prsnt } }
    assert_redirected_to check_auditoria_url(@check_auditoria)
  end

  test "should destroy check_auditoria" do
    assert_difference("CheckAuditoria.count", -1) do
      delete check_auditoria_url(@check_auditoria)
    end

    assert_redirected_to check_auditorias_url
  end
end
