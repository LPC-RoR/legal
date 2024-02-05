require 'test_helper'

class CalMesSemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cal_mes_sem = cal_mes_sems(:one)
  end

  test "should get index" do
    get cal_mes_sems_url
    assert_response :success
  end

  test "should get new" do
    get new_cal_mes_sem_url
    assert_response :success
  end

  test "should create cal_mes_sem" do
    assert_difference('CalMesSem.count') do
      post cal_mes_sems_url, params: { cal_mes_sem: { cal_mes_id: @cal_mes_sem.cal_mes_id, cal_semana_id: @cal_mes_sem.cal_semana_id } }
    end

    assert_redirected_to cal_mes_sem_url(CalMesSem.last)
  end

  test "should show cal_mes_sem" do
    get cal_mes_sem_url(@cal_mes_sem)
    assert_response :success
  end

  test "should get edit" do
    get edit_cal_mes_sem_url(@cal_mes_sem)
    assert_response :success
  end

  test "should update cal_mes_sem" do
    patch cal_mes_sem_url(@cal_mes_sem), params: { cal_mes_sem: { cal_mes_id: @cal_mes_sem.cal_mes_id, cal_semana_id: @cal_mes_sem.cal_semana_id } }
    assert_redirected_to cal_mes_sem_url(@cal_mes_sem)
  end

  test "should destroy cal_mes_sem" do
    assert_difference('CalMesSem.count', -1) do
      delete cal_mes_sem_url(@cal_mes_sem)
    end

    assert_redirected_to cal_mes_sems_url
  end
end
