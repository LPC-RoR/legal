require "test_helper"

class PdfRegistrosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pdf_registro = pdf_registros(:one)
  end

  test "should get index" do
    get pdf_registros_url
    assert_response :success
  end

  test "should get new" do
    get new_pdf_registro_url
    assert_response :success
  end

  test "should create pdf_registro" do
    assert_difference("PdfRegistro.count") do
      post pdf_registros_url, params: { pdf_registro: { ownr_id: @pdf_registro.ownr_id, ownr_type: @pdf_registro.ownr_type, pdf_archivo_id: @pdf_registro.pdf_archivo_id } }
    end

    assert_redirected_to pdf_registro_url(PdfRegistro.last)
  end

  test "should show pdf_registro" do
    get pdf_registro_url(@pdf_registro)
    assert_response :success
  end

  test "should get edit" do
    get edit_pdf_registro_url(@pdf_registro)
    assert_response :success
  end

  test "should update pdf_registro" do
    patch pdf_registro_url(@pdf_registro), params: { pdf_registro: { ownr_id: @pdf_registro.ownr_id, ownr_type: @pdf_registro.ownr_type, pdf_archivo_id: @pdf_registro.pdf_archivo_id } }
    assert_redirected_to pdf_registro_url(@pdf_registro)
  end

  test "should destroy pdf_registro" do
    assert_difference("PdfRegistro.count", -1) do
      delete pdf_registro_url(@pdf_registro)
    end

    assert_redirected_to pdf_registros_url
  end
end
