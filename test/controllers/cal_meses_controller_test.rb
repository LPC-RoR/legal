require 'test_helper'

class CalMesesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cal_mese = cal_meses(:one)
  end

  test "should get index" do
    get cal_meses_url
    assert_response :success
  end

  test "should get new" do
    get new_cal_mese_url
    assert_response :success
  end

  test "should create cal_mese" do
    assert_difference('CalMes.count') do
      post cal_meses_url, params: { cal_mese: { cal_mes: @cal_mese.cal_mes } }
    end

    assert_redirected_to cal_mese_url(CalMes.last)
  end

  test "should show cal_mese" do
    get cal_mese_url(@cal_mese)
    assert_response :success
  end

  test "should get edit" do
    get edit_cal_mese_url(@cal_mese)
    assert_response :success
  end

  test "should update cal_mese" do
    patch cal_mese_url(@cal_mese), params: { cal_mese: { cal_mes: @cal_mese.cal_mes } }
    assert_redirected_to cal_mese_url(@cal_mese)
  end

  test "should destroy cal_mese" do
    assert_difference('CalMes.count', -1) do
      delete cal_mese_url(@cal_mese)
    end

    assert_redirected_to cal_meses_url
  end
end
