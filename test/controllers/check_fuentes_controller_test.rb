require "test_helper"

class CheckFuentesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @check_fuente = check_fuentes(:one)
  end

  test "should get index" do
    get check_fuentes_url
    assert_response :success
  end

  test "should get new" do
    get new_check_fuente_url
    assert_response :success
  end

  test "should create check_fuente" do
    assert_difference("CheckFuente.count") do
      post check_fuentes_url, params: { check_fuente: { check_realizado_id: @check_fuente.check_realizado_id, fecha: @check_fuente.fecha, fuente: @check_fuente.fuente, usuario_id: @check_fuente.usuario_id } }
    end

    assert_redirected_to check_fuente_url(CheckFuente.last)
  end

  test "should show check_fuente" do
    get check_fuente_url(@check_fuente)
    assert_response :success
  end

  test "should get edit" do
    get edit_check_fuente_url(@check_fuente)
    assert_response :success
  end

  test "should update check_fuente" do
    patch check_fuente_url(@check_fuente), params: { check_fuente: { check_realizado_id: @check_fuente.check_realizado_id, fecha: @check_fuente.fecha, fuente: @check_fuente.fuente, usuario_id: @check_fuente.usuario_id } }
    assert_redirected_to check_fuente_url(@check_fuente)
  end

  test "should destroy check_fuente" do
    assert_difference("CheckFuente.count", -1) do
      delete check_fuente_url(@check_fuente)
    end

    assert_redirected_to check_fuentes_url
  end
end
