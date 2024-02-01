require 'test_helper'

class TarFormulaCuantiasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tar_formula_cuantia = tar_formula_cuantias(:one)
  end

  test "should get index" do
    get tar_formula_cuantias_url
    assert_response :success
  end

  test "should get new" do
    get new_tar_formula_cuantia_url
    assert_response :success
  end

  test "should create tar_formula_cuantia" do
    assert_difference('TarFormulaCuantia.count') do
      post tar_formula_cuantias_url, params: { tar_formula_cuantia: { tar_detalle_cuantia: @tar_formula_cuantia.tar_detalle_cuantia, tar_formula_cuantia: @tar_formula_cuantia.tar_formula_cuantia, tar_tarifa_id: @tar_formula_cuantia.tar_tarifa_id } }
    end

    assert_redirected_to tar_formula_cuantia_url(TarFormulaCuantia.last)
  end

  test "should show tar_formula_cuantia" do
    get tar_formula_cuantia_url(@tar_formula_cuantia)
    assert_response :success
  end

  test "should get edit" do
    get edit_tar_formula_cuantia_url(@tar_formula_cuantia)
    assert_response :success
  end

  test "should update tar_formula_cuantia" do
    patch tar_formula_cuantia_url(@tar_formula_cuantia), params: { tar_formula_cuantia: { tar_detalle_cuantia: @tar_formula_cuantia.tar_detalle_cuantia, tar_formula_cuantia: @tar_formula_cuantia.tar_formula_cuantia, tar_tarifa_id: @tar_formula_cuantia.tar_tarifa_id } }
    assert_redirected_to tar_formula_cuantia_url(@tar_formula_cuantia)
  end

  test "should destroy tar_formula_cuantia" do
    assert_difference('TarFormulaCuantia.count', -1) do
      delete tar_formula_cuantia_url(@tar_formula_cuantia)
    end

    assert_redirected_to tar_formula_cuantias_url
  end
end
