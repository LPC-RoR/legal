require 'test_helper'

class RegistrosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @registro = registros(:one)
  end

  test "should get index" do
    get registros_url
    assert_response :success
  end

  test "should get new" do
    get new_registro_url
    assert_response :success
  end

  test "should create registro" do
    assert_difference('Registro.count') do
      post registros_url, params: { registro: { descuento: @registro.descuento, detalle: @registro.detalle, duracion.time: @registro.duracion.time, estado: @registro.estado, fecha: @registro.fecha, nota: @registro.nota, owner_class: @registro.owner_class, owner_id: @registro.owner_id, razon_descuento: @registro.razon_descuento, tipo: @registro.tipo } }
    end

    assert_redirected_to registro_url(Registro.last)
  end

  test "should show registro" do
    get registro_url(@registro)
    assert_response :success
  end

  test "should get edit" do
    get edit_registro_url(@registro)
    assert_response :success
  end

  test "should update registro" do
    patch registro_url(@registro), params: { registro: { descuento: @registro.descuento, detalle: @registro.detalle, duracion.time: @registro.duracion.time, estado: @registro.estado, fecha: @registro.fecha, nota: @registro.nota, owner_class: @registro.owner_class, owner_id: @registro.owner_id, razon_descuento: @registro.razon_descuento, tipo: @registro.tipo } }
    assert_redirected_to registro_url(@registro)
  end

  test "should destroy registro" do
    assert_difference('Registro.count', -1) do
      delete registro_url(@registro)
    end

    assert_redirected_to registros_url
  end
end
