require 'test_helper'

class TipoAsesoriasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tipo_asesoria = tipo_asesorias(:one)
  end

  test "should get index" do
    get tipo_asesorias_url
    assert_response :success
  end

  test "should get new" do
    get new_tipo_asesoria_url
    assert_response :success
  end

  test "should create tipo_asesoria" do
    assert_difference('TipoAsesoria.count') do
      post tipo_asesorias_url, params: { tipo_asesoria: { archivos: @tipo_asesoria.archivos, documento: @tipo_asesoria.documento, facturable: @tipo_asesoria.facturable, tipo_asesoria: @tipo_asesoria.tipo_asesoria } }
    end

    assert_redirected_to tipo_asesoria_url(TipoAsesoria.last)
  end

  test "should show tipo_asesoria" do
    get tipo_asesoria_url(@tipo_asesoria)
    assert_response :success
  end

  test "should get edit" do
    get edit_tipo_asesoria_url(@tipo_asesoria)
    assert_response :success
  end

  test "should update tipo_asesoria" do
    patch tipo_asesoria_url(@tipo_asesoria), params: { tipo_asesoria: { archivos: @tipo_asesoria.archivos, documento: @tipo_asesoria.documento, facturable: @tipo_asesoria.facturable, tipo_asesoria: @tipo_asesoria.tipo_asesoria } }
    assert_redirected_to tipo_asesoria_url(@tipo_asesoria)
  end

  test "should destroy tipo_asesoria" do
    assert_difference('TipoAsesoria.count', -1) do
      delete tipo_asesoria_url(@tipo_asesoria)
    end

    assert_redirected_to tipo_asesorias_url
  end
end
