require 'test_helper'

class TarServiciosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tar_servicio = tar_servicios(:one)
  end

  test "should get index" do
    get tar_servicios_url
    assert_response :success
  end

  test "should get new" do
    get new_tar_servicio_url
    assert_response :success
  end

  test "should create tar_servicio" do
    assert_difference('TarServicio.count') do
      post tar_servicios_url, params: { tar_servicio: { codigo: @tar_servicio.codigo, descripcion: @tar_servicio.descripcion, detalle: @tar_servicio.detalle, moneda: @tar_servicio.moneda, monto: @tar_servicio.monto, objeto_id: @tar_servicio.objeto_id, owner_class: @tar_servicio.owner_class, tipo: @tar_servicio.tipo } }
    end

    assert_redirected_to tar_servicio_url(TarServicio.last)
  end

  test "should show tar_servicio" do
    get tar_servicio_url(@tar_servicio)
    assert_response :success
  end

  test "should get edit" do
    get edit_tar_servicio_url(@tar_servicio)
    assert_response :success
  end

  test "should update tar_servicio" do
    patch tar_servicio_url(@tar_servicio), params: { tar_servicio: { codigo: @tar_servicio.codigo, descripcion: @tar_servicio.descripcion, detalle: @tar_servicio.detalle, moneda: @tar_servicio.moneda, monto: @tar_servicio.monto, objeto_id: @tar_servicio.objeto_id, owner_class: @tar_servicio.owner_class, tipo: @tar_servicio.tipo } }
    assert_redirected_to tar_servicio_url(@tar_servicio)
  end

  test "should destroy tar_servicio" do
    assert_difference('TarServicio.count', -1) do
      delete tar_servicio_url(@tar_servicio)
    end

    assert_redirected_to tar_servicios_url
  end
end
