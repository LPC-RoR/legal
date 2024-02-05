require 'test_helper'

class CalSemanasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cal_semana = cal_semanas(:one)
  end

  test "should get index" do
    get cal_semanas_url
    assert_response :success
  end

  test "should get new" do
    get new_cal_semana_url
    assert_response :success
  end

  test "should create cal_semana" do
    assert_difference('CalSemana.count') do
      post cal_semanas_url, params: { cal_semana: { cal_semana: @cal_semana.cal_semana } }
    end

    assert_redirected_to cal_semana_url(CalSemana.last)
  end

  test "should show cal_semana" do
    get cal_semana_url(@cal_semana)
    assert_response :success
  end

  test "should get edit" do
    get edit_cal_semana_url(@cal_semana)
    assert_response :success
  end

  test "should update cal_semana" do
    patch cal_semana_url(@cal_semana), params: { cal_semana: { cal_semana: @cal_semana.cal_semana } }
    assert_redirected_to cal_semana_url(@cal_semana)
  end

  test "should destroy cal_semana" do
    assert_difference('CalSemana.count', -1) do
      delete cal_semana_url(@cal_semana)
    end

    assert_redirected_to cal_semanas_url
  end
end
