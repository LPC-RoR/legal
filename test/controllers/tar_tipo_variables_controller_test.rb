require "test_helper"

class TarTipoVariablesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tar_tipo_variable = tar_tipo_variables(:one)
  end

  test "should get index" do
    get tar_tipo_variables_url
    assert_response :success
  end

  test "should get new" do
    get new_tar_tipo_variable_url
    assert_response :success
  end

  test "should create tar_tipo_variable" do
    assert_difference("TarTipoVariable.count") do
      post tar_tipo_variables_url, params: { tar_tipo_variable: { tar_tarifa_id: @tar_tipo_variable.tar_tarifa_id, tipo_causa_id: @tar_tipo_variable.tipo_causa_id, variable_tipo_causa: @tar_tipo_variable.variable_tipo_causa } }
    end

    assert_redirected_to tar_tipo_variable_url(TarTipoVariable.last)
  end

  test "should show tar_tipo_variable" do
    get tar_tipo_variable_url(@tar_tipo_variable)
    assert_response :success
  end

  test "should get edit" do
    get edit_tar_tipo_variable_url(@tar_tipo_variable)
    assert_response :success
  end

  test "should update tar_tipo_variable" do
    patch tar_tipo_variable_url(@tar_tipo_variable), params: { tar_tipo_variable: { tar_tarifa_id: @tar_tipo_variable.tar_tarifa_id, tipo_causa_id: @tar_tipo_variable.tipo_causa_id, variable_tipo_causa: @tar_tipo_variable.variable_tipo_causa } }
    assert_redirected_to tar_tipo_variable_url(@tar_tipo_variable)
  end

  test "should destroy tar_tipo_variable" do
    assert_difference("TarTipoVariable.count", -1) do
      delete tar_tipo_variable_url(@tar_tipo_variable)
    end

    assert_redirected_to tar_tipo_variables_url
  end
end
