require 'test_helper'

class RegReportesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @reg_reporte = reg_reportes(:one)
  end

  test "should get index" do
    get reg_reportes_url
    assert_response :success
  end

  test "should get new" do
    get new_reg_reporte_url
    assert_response :success
  end

  test "should create reg_reporte" do
    assert_difference('RegReporte.count') do
      post reg_reportes_url, params: { reg_reporte: { clave: @reg_reporte.clave } }
    end

    assert_redirected_to reg_reporte_url(RegReporte.last)
  end

  test "should show reg_reporte" do
    get reg_reporte_url(@reg_reporte)
    assert_response :success
  end

  test "should get edit" do
    get edit_reg_reporte_url(@reg_reporte)
    assert_response :success
  end

  test "should update reg_reporte" do
    patch reg_reporte_url(@reg_reporte), params: { reg_reporte: { clave: @reg_reporte.clave } }
    assert_redirected_to reg_reporte_url(@reg_reporte)
  end

  test "should destroy reg_reporte" do
    assert_difference('RegReporte.count', -1) do
      delete reg_reporte_url(@reg_reporte)
    end

    assert_redirected_to reg_reportes_url
  end
end
