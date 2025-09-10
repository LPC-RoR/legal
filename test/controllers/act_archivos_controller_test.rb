require "test_helper"

class ActArchivosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @act_archivo = act_archivos(:one)
  end

  test "should get index" do
    get act_archivos_url
    assert_response :success
  end

  test "should get new" do
    get new_act_archivo_url
    assert_response :success
  end

  test "should create act_archivo" do
    assert_difference("ActArchivo.count") do
      post act_archivos_url, params: { act_archivo: { act_archivo: @act_archivo.act_archivo, nombre: @act_archivo.nombre } }
    end

    assert_redirected_to act_archivo_url(ActArchivo.last)
  end

  test "should show act_archivo" do
    get act_archivo_url(@act_archivo)
    assert_response :success
  end

  test "should get edit" do
    get edit_act_archivo_url(@act_archivo)
    assert_response :success
  end

  test "should update act_archivo" do
    patch act_archivo_url(@act_archivo), params: { act_archivo: { act_archivo: @act_archivo.act_archivo, nombre: @act_archivo.nombre } }
    assert_redirected_to act_archivo_url(@act_archivo)
  end

  test "should destroy act_archivo" do
    assert_difference("ActArchivo.count", -1) do
      delete act_archivo_url(@act_archivo)
    end

    assert_redirected_to act_archivos_url
  end
end
