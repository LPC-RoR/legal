require 'test_helper'

class CargosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cargo = cargos(:one)
  end

  test "should get index" do
    get cargos_url
    assert_response :success
  end

  test "should get new" do
    get new_cargo_url
    assert_response :success
  end

  test "should create cargo" do
    assert_difference('Cargo.count') do
      post cargos_url, params: { cargo: { cargo: @cargo.cargo, cliente_id: @cargo.cliente_id, detalle: @cargo.detalle, dia_cargo: @cargo.dia_cargo, fecha: @cargo.fecha, fecha_uf: @cargo.fecha_uf, moneda: @cargo.moneda, tipo_cargo_id: @cargo.tipo_cargo_id } }
    end

    assert_redirected_to cargo_url(Cargo.last)
  end

  test "should show cargo" do
    get cargo_url(@cargo)
    assert_response :success
  end

  test "should get edit" do
    get edit_cargo_url(@cargo)
    assert_response :success
  end

  test "should update cargo" do
    patch cargo_url(@cargo), params: { cargo: { cargo: @cargo.cargo, cliente_id: @cargo.cliente_id, detalle: @cargo.detalle, dia_cargo: @cargo.dia_cargo, fecha: @cargo.fecha, fecha_uf: @cargo.fecha_uf, moneda: @cargo.moneda, tipo_cargo_id: @cargo.tipo_cargo_id } }
    assert_redirected_to cargo_url(@cargo)
  end

  test "should destroy cargo" do
    assert_difference('Cargo.count', -1) do
      delete cargo_url(@cargo)
    end

    assert_redirected_to cargos_url
  end
end
