require "test_helper"

class RepArchivosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @rep_archivo = rep_archivos(:one)
  end

  test "should get index" do
    get rep_archivos_url
    assert_response :success
  end

  test "should get new" do
    get new_rep_archivo_url
    assert_response :success
  end

  test "should create rep_archivo" do
    assert_difference("RepArchivo.count") do
      post rep_archivos_url, params: { rep_archivo: { archivo: @rep_archivo.archivo, ownr_id: @rep_archivo.ownr_id, ownr_type: @rep_archivo.ownr_type, rep_archivo: @rep_archivo.rep_archivo, rep_doc_controlado_id: @rep_archivo.rep_doc_controlado_id } }
    end

    assert_redirected_to rep_archivo_url(RepArchivo.last)
  end

  test "should show rep_archivo" do
    get rep_archivo_url(@rep_archivo)
    assert_response :success
  end

  test "should get edit" do
    get edit_rep_archivo_url(@rep_archivo)
    assert_response :success
  end

  test "should update rep_archivo" do
    patch rep_archivo_url(@rep_archivo), params: { rep_archivo: { archivo: @rep_archivo.archivo, ownr_id: @rep_archivo.ownr_id, ownr_type: @rep_archivo.ownr_type, rep_archivo: @rep_archivo.rep_archivo, rep_doc_controlado_id: @rep_archivo.rep_doc_controlado_id } }
    assert_redirected_to rep_archivo_url(@rep_archivo)
  end

  test "should destroy rep_archivo" do
    assert_difference("RepArchivo.count", -1) do
      delete rep_archivo_url(@rep_archivo)
    end

    assert_redirected_to rep_archivos_url
  end
end
