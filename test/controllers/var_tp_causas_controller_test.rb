require 'test_helper'

class VarTpCausasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @var_tp_causa = var_tp_causas(:one)
  end

  test "should get index" do
    get var_tp_causas_url
    assert_response :success
  end

  test "should get new" do
    get new_var_tp_causa_url
    assert_response :success
  end

  test "should create var_tp_causa" do
    assert_difference('VarTpCausa.count') do
      post var_tp_causas_url, params: { var_tp_causa: { tipo_causa_id: @var_tp_causa.tipo_causa_id, variable_id: @var_tp_causa.variable_id } }
    end

    assert_redirected_to var_tp_causa_url(VarTpCausa.last)
  end

  test "should show var_tp_causa" do
    get var_tp_causa_url(@var_tp_causa)
    assert_response :success
  end

  test "should get edit" do
    get edit_var_tp_causa_url(@var_tp_causa)
    assert_response :success
  end

  test "should update var_tp_causa" do
    patch var_tp_causa_url(@var_tp_causa), params: { var_tp_causa: { tipo_causa_id: @var_tp_causa.tipo_causa_id, variable_id: @var_tp_causa.variable_id } }
    assert_redirected_to var_tp_causa_url(@var_tp_causa)
  end

  test "should destroy var_tp_causa" do
    assert_difference('VarTpCausa.count', -1) do
      delete var_tp_causa_url(@var_tp_causa)
    end

    assert_redirected_to var_tp_causas_url
  end
end
