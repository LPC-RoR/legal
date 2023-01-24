require 'test_helper'

class TipoCausasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tipo_causa = tipo_causas(:one)
  end

  test "should get index" do
    get tipo_causas_url
    assert_response :success
  end

  test "should get new" do
    get new_tipo_causa_url
    assert_response :success
  end

  test "should create tipo_causa" do
    assert_difference('TipoCausa.count') do
      post tipo_causas_url, params: { tipo_causa: { tipo_causa: @tipo_causa.tipo_causa } }
    end

    assert_redirected_to tipo_causa_url(TipoCausa.last)
  end

  test "should show tipo_causa" do
    get tipo_causa_url(@tipo_causa)
    assert_response :success
  end

  test "should get edit" do
    get edit_tipo_causa_url(@tipo_causa)
    assert_response :success
  end

  test "should update tipo_causa" do
    patch tipo_causa_url(@tipo_causa), params: { tipo_causa: { tipo_causa: @tipo_causa.tipo_causa } }
    assert_redirected_to tipo_causa_url(@tipo_causa)
  end

  test "should destroy tipo_causa" do
    assert_difference('TipoCausa.count', -1) do
      delete tipo_causa_url(@tipo_causa)
    end

    assert_redirected_to tipo_causas_url
  end
end
