require 'test_helper'

class TarVariablesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tar_variable = tar_variables(:one)
  end

  test "should get index" do
    get tar_variables_url
    assert_response :success
  end

  test "should get new" do
    get new_tar_variable_url
    assert_response :success
  end

  test "should create tar_variable" do
    assert_difference('TarVariable.count') do
      post tar_variables_url, params: { tar_variable: { owner_class: @tar_variable.owner_class, owner_id: @tar_variable.owner_id, porcentaje: @tar_variable.porcentaje, variable: @tar_variable.variable } }
    end

    assert_redirected_to tar_variable_url(TarVariable.last)
  end

  test "should show tar_variable" do
    get tar_variable_url(@tar_variable)
    assert_response :success
  end

  test "should get edit" do
    get edit_tar_variable_url(@tar_variable)
    assert_response :success
  end

  test "should update tar_variable" do
    patch tar_variable_url(@tar_variable), params: { tar_variable: { owner_class: @tar_variable.owner_class, owner_id: @tar_variable.owner_id, porcentaje: @tar_variable.porcentaje, variable: @tar_variable.variable } }
    assert_redirected_to tar_variable_url(@tar_variable)
  end

  test "should destroy tar_variable" do
    assert_difference('TarVariable.count', -1) do
      delete tar_variable_url(@tar_variable)
    end

    assert_redirected_to tar_variables_url
  end
end
