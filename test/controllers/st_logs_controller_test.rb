require 'test_helper'

class StLogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @st_log = st_logs(:one)
  end

  test "should get index" do
    get st_logs_url
    assert_response :success
  end

  test "should get new" do
    get new_st_log_url
    assert_response :success
  end

  test "should create st_log" do
    assert_difference('StLog.count') do
      post st_logs_url, params: { st_log: { class_name: @st_log.class_name, e_destino: @st_log.e_destino, e_origen: @st_log.e_origen, objeto_id: @st_log.objeto_id, perfil_id: @st_log.perfil_id } }
    end

    assert_redirected_to st_log_url(StLog.last)
  end

  test "should show st_log" do
    get st_log_url(@st_log)
    assert_response :success
  end

  test "should get edit" do
    get edit_st_log_url(@st_log)
    assert_response :success
  end

  test "should update st_log" do
    patch st_log_url(@st_log), params: { st_log: { class_name: @st_log.class_name, e_destino: @st_log.e_destino, e_origen: @st_log.e_origen, objeto_id: @st_log.objeto_id, perfil_id: @st_log.perfil_id } }
    assert_redirected_to st_log_url(@st_log)
  end

  test "should destroy st_log" do
    assert_difference('StLog.count', -1) do
      delete st_log_url(@st_log)
    end

    assert_redirected_to st_logs_url
  end
end
