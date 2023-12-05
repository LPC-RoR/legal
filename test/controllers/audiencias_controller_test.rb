require 'test_helper'

class AudienciasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @audiencia = audiencias(:one)
  end

  test "should get index" do
    get audiencias_url
    assert_response :success
  end

  test "should get new" do
    get new_audiencia_url
    assert_response :success
  end

  test "should create audiencia" do
    assert_difference('Audiencia.count') do
      post audiencias_url, params: { audiencia: { audiencia: @audiencia.audiencia, tipo: @audiencia.tipo, tipo_causa_id: @audiencia.tipo_causa_id } }
    end

    assert_redirected_to audiencia_url(Audiencia.last)
  end

  test "should show audiencia" do
    get audiencia_url(@audiencia)
    assert_response :success
  end

  test "should get edit" do
    get edit_audiencia_url(@audiencia)
    assert_response :success
  end

  test "should update audiencia" do
    patch audiencia_url(@audiencia), params: { audiencia: { audiencia: @audiencia.audiencia, tipo: @audiencia.tipo, tipo_causa_id: @audiencia.tipo_causa_id } }
    assert_redirected_to audiencia_url(@audiencia)
  end

  test "should destroy audiencia" do
    assert_difference('Audiencia.count', -1) do
      delete audiencia_url(@audiencia)
    end

    assert_redirected_to audiencias_url
  end
end
