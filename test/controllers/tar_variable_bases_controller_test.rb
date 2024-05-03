require 'test_helper'

class TarVariableBasesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tar_variable_bas = tar_variable_bases(:one)
  end

  test "should get index" do
    get tar_variable_bases_url
    assert_response :success
  end

  test "should get new" do
    get new_tar_variable_bas_url
    assert_response :success
  end

  test "should create tar_variable_bas" do
    assert_difference('TarVariableBase.count') do
      post tar_variable_bases_url, params: { tar_variable_bas: { tar_base_variable: @tar_variable_bas.tar_base_variable, tar_tarifa_id: @tar_variable_bas.tar_tarifa_id, tipo_causa_id: @tar_variable_bas.tipo_causa_id } }
    end

    assert_redirected_to tar_variable_bas_url(TarVariableBase.last)
  end

  test "should show tar_variable_bas" do
    get tar_variable_bas_url(@tar_variable_bas)
    assert_response :success
  end

  test "should get edit" do
    get edit_tar_variable_bas_url(@tar_variable_bas)
    assert_response :success
  end

  test "should update tar_variable_bas" do
    patch tar_variable_bas_url(@tar_variable_bas), params: { tar_variable_bas: { tar_base_variable: @tar_variable_bas.tar_base_variable, tar_tarifa_id: @tar_variable_bas.tar_tarifa_id, tipo_causa_id: @tar_variable_bas.tipo_causa_id } }
    assert_redirected_to tar_variable_bas_url(@tar_variable_bas)
  end

  test "should destroy tar_variable_bas" do
    assert_difference('TarVariableBase.count', -1) do
      delete tar_variable_bas_url(@tar_variable_bas)
    end

    assert_redirected_to tar_variable_bases_url
  end
end
