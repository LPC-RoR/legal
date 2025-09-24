require "test_helper"

class CheckRealizadosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @check_realizado = check_realizados(:one)
  end

  test "should get index" do
    get check_realizados_url
    assert_response :success
  end

  test "should get new" do
    get new_check_realizado_url
    assert_response :success
  end

  test "should create check_realizado" do
    assert_difference("CheckRealizado.count") do
      post check_realizados_url, params: { check_realizado: { app_perfil_id: @check_realizado.app_perfil_id, cdg: @check_realizado.cdg, chequed_at: @check_realizado.chequed_at, mdl: @check_realizado.mdl, ownr_id: @check_realizado.ownr_id, ownr_type: @check_realizado.ownr_type, rlzd: @check_realizado.rlzd } }
    end

    assert_redirected_to check_realizado_url(CheckRealizado.last)
  end

  test "should show check_realizado" do
    get check_realizado_url(@check_realizado)
    assert_response :success
  end

  test "should get edit" do
    get edit_check_realizado_url(@check_realizado)
    assert_response :success
  end

  test "should update check_realizado" do
    patch check_realizado_url(@check_realizado), params: { check_realizado: { app_perfil_id: @check_realizado.app_perfil_id, cdg: @check_realizado.cdg, chequed_at: @check_realizado.chequed_at, mdl: @check_realizado.mdl, ownr_id: @check_realizado.ownr_id, ownr_type: @check_realizado.ownr_type, rlzd: @check_realizado.rlzd } }
    assert_redirected_to check_realizado_url(@check_realizado)
  end

  test "should destroy check_realizado" do
    assert_difference("CheckRealizado.count", -1) do
      delete check_realizado_url(@check_realizado)
    end

    assert_redirected_to check_realizados_url
  end
end
