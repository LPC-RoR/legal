require "test_helper"

class KrnReportesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @krn_reporte = krn_reportes(:one)
  end

  test "should get index" do
    get krn_reportes_url
    assert_response :success
  end

  test "should get new" do
    get new_krn_reporte_url
    assert_response :success
  end

  test "should create krn_reporte" do
    assert_difference("KrnReporte.count") do
      post krn_reportes_url, params: { krn_reporte: {} }
    end

    assert_redirected_to krn_reporte_url(KrnReporte.last)
  end

  test "should show krn_reporte" do
    get krn_reporte_url(@krn_reporte)
    assert_response :success
  end

  test "should get edit" do
    get edit_krn_reporte_url(@krn_reporte)
    assert_response :success
  end

  test "should update krn_reporte" do
    patch krn_reporte_url(@krn_reporte), params: { krn_reporte: {} }
    assert_redirected_to krn_reporte_url(@krn_reporte)
  end

  test "should destroy krn_reporte" do
    assert_difference("KrnReporte.count", -1) do
      delete krn_reporte_url(@krn_reporte)
    end

    assert_redirected_to krn_reportes_url
  end
end
