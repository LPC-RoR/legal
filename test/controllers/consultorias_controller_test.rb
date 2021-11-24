require 'test_helper'

class ConsultoriasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @consultoria = consultorias(:one)
  end

  test "should get index" do
    get consultorias_url
    assert_response :success
  end

  test "should get new" do
    get new_consultoria_url
    assert_response :success
  end

  test "should create consultoria" do
    assert_difference('Consultoria.count') do
      post consultorias_url, params: { consultoria: { cliente_id: @consultoria.cliente_id, consultoria: @consultoria.consultoria, estado: @consultoria.estado, tar_tarea_id: @consultoria.tar_tarea_id } }
    end

    assert_redirected_to consultoria_url(Consultoria.last)
  end

  test "should show consultoria" do
    get consultoria_url(@consultoria)
    assert_response :success
  end

  test "should get edit" do
    get edit_consultoria_url(@consultoria)
    assert_response :success
  end

  test "should update consultoria" do
    patch consultoria_url(@consultoria), params: { consultoria: { cliente_id: @consultoria.cliente_id, consultoria: @consultoria.consultoria, estado: @consultoria.estado, tar_tarea_id: @consultoria.tar_tarea_id } }
    assert_redirected_to consultoria_url(@consultoria)
  end

  test "should destroy consultoria" do
    assert_difference('Consultoria.count', -1) do
      delete consultoria_url(@consultoria)
    end

    assert_redirected_to consultorias_url
  end
end
