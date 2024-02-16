require 'test_helper'

class AgeLogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @age_log = age_logs(:one)
  end

  test "should get index" do
    get age_logs_url
    assert_response :success
  end

  test "should get new" do
    get new_age_log_url
    assert_response :success
  end

  test "should create age_log" do
    assert_difference('AgeLog.count') do
      post age_logs_url, params: { age_log: { age_actividad: @age_log.age_actividad, age_actividad_id: @age_log.age_actividad_id, fecha: @age_log.fecha } }
    end

    assert_redirected_to age_log_url(AgeLog.last)
  end

  test "should show age_log" do
    get age_log_url(@age_log)
    assert_response :success
  end

  test "should get edit" do
    get edit_age_log_url(@age_log)
    assert_response :success
  end

  test "should update age_log" do
    patch age_log_url(@age_log), params: { age_log: { age_actividad: @age_log.age_actividad, age_actividad_id: @age_log.age_actividad_id, fecha: @age_log.fecha } }
    assert_redirected_to age_log_url(@age_log)
  end

  test "should destroy age_log" do
    assert_difference('AgeLog.count', -1) do
      delete age_log_url(@age_log)
    end

    assert_redirected_to age_logs_url
  end
end
