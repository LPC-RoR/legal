require 'test_helper'

class CalDiasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cal_dia = cal_dias(:one)
  end

  test "should get index" do
    get cal_dias_url
    assert_response :success
  end

  test "should get new" do
    get new_cal_dia_url
    assert_response :success
  end

  test "should create cal_dia" do
    assert_difference('CalDia.count') do
      post cal_dias_url, params: { cal_dia: { cal_dia: @cal_dia.cal_dia } }
    end

    assert_redirected_to cal_dia_url(CalDia.last)
  end

  test "should show cal_dia" do
    get cal_dia_url(@cal_dia)
    assert_response :success
  end

  test "should get edit" do
    get edit_cal_dia_url(@cal_dia)
    assert_response :success
  end

  test "should update cal_dia" do
    patch cal_dia_url(@cal_dia), params: { cal_dia: { cal_dia: @cal_dia.cal_dia } }
    assert_redirected_to cal_dia_url(@cal_dia)
  end

  test "should destroy cal_dia" do
    assert_difference('CalDia.count', -1) do
      delete cal_dia_url(@cal_dia)
    end

    assert_redirected_to cal_dias_url
  end
end
