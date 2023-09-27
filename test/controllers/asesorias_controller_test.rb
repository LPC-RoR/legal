require 'test_helper'

class AsesoriasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @asesoria = asesorias(:one)
  end

  test "should get index" do
    get asesorias_url
    assert_response :success
  end

  test "should get new" do
    get new_asesoria_url
    assert_response :success
  end

  test "should create asesoria" do
    assert_difference('Asesoria.count') do
      post asesorias_url, params: { asesoria: { cliente_id: @asesoria.cliente_id, descripcion: @asesoria.descripcion, detalle: @asesoria.detalle, fecha: @asesoria.fecha, plazo: @asesoria.plazo, tar_servicio_id: @asesoria.tar_servicio_id } }
    end

    assert_redirected_to asesoria_url(Asesoria.last)
  end

  test "should show asesoria" do
    get asesoria_url(@asesoria)
    assert_response :success
  end

  test "should get edit" do
    get edit_asesoria_url(@asesoria)
    assert_response :success
  end

  test "should update asesoria" do
    patch asesoria_url(@asesoria), params: { asesoria: { cliente_id: @asesoria.cliente_id, descripcion: @asesoria.descripcion, detalle: @asesoria.detalle, fecha: @asesoria.fecha, plazo: @asesoria.plazo, tar_servicio_id: @asesoria.tar_servicio_id } }
    assert_redirected_to asesoria_url(@asesoria)
  end

  test "should destroy asesoria" do
    assert_difference('Asesoria.count', -1) do
      delete asesoria_url(@asesoria)
    end

    assert_redirected_to asesorias_url
  end
end
