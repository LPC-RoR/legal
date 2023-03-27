require 'test_helper'

class TarFormulasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tar_formula = tar_formulas(:one)
  end

  test "should get index" do
    get tar_formulas_url
    assert_response :success
  end

  test "should get new" do
    get new_tar_formula_url
    assert_response :success
  end

  test "should create tar_formula" do
    assert_difference('TarFormula.count') do
      post tar_formulas_url, params: { tar_formula: { error: @tar_formula.error, mensaje: @tar_formula.mensaje, orden: @tar_formula.orden, tar_formula: @tar_formula.tar_formula, tar_pago_id: @tar_formula.tar_pago_id } }
    end

    assert_redirected_to tar_formula_url(TarFormula.last)
  end

  test "should show tar_formula" do
    get tar_formula_url(@tar_formula)
    assert_response :success
  end

  test "should get edit" do
    get edit_tar_formula_url(@tar_formula)
    assert_response :success
  end

  test "should update tar_formula" do
    patch tar_formula_url(@tar_formula), params: { tar_formula: { error: @tar_formula.error, mensaje: @tar_formula.mensaje, orden: @tar_formula.orden, tar_formula: @tar_formula.tar_formula, tar_pago_id: @tar_formula.tar_pago_id } }
    assert_redirected_to tar_formula_url(@tar_formula)
  end

  test "should destroy tar_formula" do
    assert_difference('TarFormula.count', -1) do
      delete tar_formula_url(@tar_formula)
    end

    assert_redirected_to tar_formulas_url
  end
end
