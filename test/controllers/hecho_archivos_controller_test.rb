require 'test_helper'

class HechoArchivosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @hecho_archivo = hecho_archivos(:one)
  end

  test "should get index" do
    get hecho_archivos_url
    assert_response :success
  end

  test "should get new" do
    get new_hecho_archivo_url
    assert_response :success
  end

  test "should create hecho_archivo" do
    assert_difference('HechoArchivo.count') do
      post hecho_archivos_url, params: { hecho_archivo: { app_archivo_id: @hecho_archivo.app_archivo_id, establece: @hecho_archivo.establece, hecho_id: @hecho_archivo.hecho_id, orden: @hecho_archivo.orden } }
    end

    assert_redirected_to hecho_archivo_url(HechoArchivo.last)
  end

  test "should show hecho_archivo" do
    get hecho_archivo_url(@hecho_archivo)
    assert_response :success
  end

  test "should get edit" do
    get edit_hecho_archivo_url(@hecho_archivo)
    assert_response :success
  end

  test "should update hecho_archivo" do
    patch hecho_archivo_url(@hecho_archivo), params: { hecho_archivo: { app_archivo_id: @hecho_archivo.app_archivo_id, establece: @hecho_archivo.establece, hecho_id: @hecho_archivo.hecho_id, orden: @hecho_archivo.orden } }
    assert_redirected_to hecho_archivo_url(@hecho_archivo)
  end

  test "should destroy hecho_archivo" do
    assert_difference('HechoArchivo.count', -1) do
      delete hecho_archivo_url(@hecho_archivo)
    end

    assert_redirected_to hecho_archivos_url
  end
end
