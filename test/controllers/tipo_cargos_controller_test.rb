require 'test_helper'

class TipoCargosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tipo_cargo = tipo_cargos(:one)
  end

  test "should get index" do
    get tipo_cargos_url
    assert_response :success
  end

  test "should get new" do
    get new_tipo_cargo_url
    assert_response :success
  end

  test "should create tipo_cargo" do
    assert_difference('TipoCargo.count') do
      post tipo_cargos_url, params: { tipo_cargo: { tipo_cargo: @tipo_cargo.tipo_cargo } }
    end

    assert_redirected_to tipo_cargo_url(TipoCargo.last)
  end

  test "should show tipo_cargo" do
    get tipo_cargo_url(@tipo_cargo)
    assert_response :success
  end

  test "should get edit" do
    get edit_tipo_cargo_url(@tipo_cargo)
    assert_response :success
  end

  test "should update tipo_cargo" do
    patch tipo_cargo_url(@tipo_cargo), params: { tipo_cargo: { tipo_cargo: @tipo_cargo.tipo_cargo } }
    assert_redirected_to tipo_cargo_url(@tipo_cargo)
  end

  test "should destroy tipo_cargo" do
    assert_difference('TipoCargo.count', -1) do
      delete tipo_cargo_url(@tipo_cargo)
    end

    assert_redirected_to tipo_cargos_url
  end
end
