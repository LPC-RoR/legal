require "test_helper"

class PdfArchivosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pdf_archivo = pdf_archivos(:one)
  end

  test "should get index" do
    get pdf_archivos_url
    assert_response :success
  end

  test "should get new" do
    get new_pdf_archivo_url
    assert_response :success
  end

  test "should create pdf_archivo" do
    assert_difference("PdfArchivo.count") do
      post pdf_archivos_url, params: { pdf_archivo: { codigo: @pdf_archivo.codigo, modelos: @pdf_archivo.modelos, nombre: @pdf_archivo.nombre, ownr_id: @pdf_archivo.ownr_id, ownr_type: @pdf_archivo.ownr_type } }
    end

    assert_redirected_to pdf_archivo_url(PdfArchivo.last)
  end

  test "should show pdf_archivo" do
    get pdf_archivo_url(@pdf_archivo)
    assert_response :success
  end

  test "should get edit" do
    get edit_pdf_archivo_url(@pdf_archivo)
    assert_response :success
  end

  test "should update pdf_archivo" do
    patch pdf_archivo_url(@pdf_archivo), params: { pdf_archivo: { codigo: @pdf_archivo.codigo, modelos: @pdf_archivo.modelos, nombre: @pdf_archivo.nombre, ownr_id: @pdf_archivo.ownr_id, ownr_type: @pdf_archivo.ownr_type } }
    assert_redirected_to pdf_archivo_url(@pdf_archivo)
  end

  test "should destroy pdf_archivo" do
    assert_difference("PdfArchivo.count", -1) do
      delete pdf_archivo_url(@pdf_archivo)
    end

    assert_redirected_to pdf_archivos_url
  end
end
