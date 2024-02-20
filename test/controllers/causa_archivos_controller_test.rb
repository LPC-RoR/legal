require 'test_helper'

class CausaArchivosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @causa_archivo = causa_archivos(:one)
  end

  test "should get index" do
    get causa_archivos_url
    assert_response :success
  end

  test "should get new" do
    get new_causa_archivo_url
    assert_response :success
  end

  test "should create causa_archivo" do
    assert_difference('CausaArchivo.count') do
      post causa_archivos_url, params: { causa_archivo: { app_archivo_id: @causa_archivo.app_archivo_id, causa_id: @causa_archivo.causa_id, orden: @causa_archivo.orden, seleccionado: @causa_archivo.seleccionado } }
    end

    assert_redirected_to causa_archivo_url(CausaArchivo.last)
  end

  test "should show causa_archivo" do
    get causa_archivo_url(@causa_archivo)
    assert_response :success
  end

  test "should get edit" do
    get edit_causa_archivo_url(@causa_archivo)
    assert_response :success
  end

  test "should update causa_archivo" do
    patch causa_archivo_url(@causa_archivo), params: { causa_archivo: { app_archivo_id: @causa_archivo.app_archivo_id, causa_id: @causa_archivo.causa_id, orden: @causa_archivo.orden, seleccionado: @causa_archivo.seleccionado } }
    assert_redirected_to causa_archivo_url(@causa_archivo)
  end

  test "should destroy causa_archivo" do
    assert_difference('CausaArchivo.count', -1) do
      delete causa_archivo_url(@causa_archivo)
    end

    assert_redirected_to causa_archivos_url
  end
end
