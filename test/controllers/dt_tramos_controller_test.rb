require "test_helper"

class DtTramosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @dt_tramo = dt_tramos(:one)
  end

  test "should get index" do
    get dt_tramos_url
    assert_response :success
  end

  test "should get new" do
    get new_dt_tramo_url
    assert_response :success
  end

  test "should create dt_tramo" do
    assert_difference("DtTramo.count") do
      post dt_tramos_url, params: { dt_tramo: { dt_tramo: @dt_tramo.dt_tramo, max: @dt_tramo.max, min: @dt_tramo.min, orden: @dt_tramo.orden } }
    end

    assert_redirected_to dt_tramo_url(DtTramo.last)
  end

  test "should show dt_tramo" do
    get dt_tramo_url(@dt_tramo)
    assert_response :success
  end

  test "should get edit" do
    get edit_dt_tramo_url(@dt_tramo)
    assert_response :success
  end

  test "should update dt_tramo" do
    patch dt_tramo_url(@dt_tramo), params: { dt_tramo: { dt_tramo: @dt_tramo.dt_tramo, max: @dt_tramo.max, min: @dt_tramo.min, orden: @dt_tramo.orden } }
    assert_redirected_to dt_tramo_url(@dt_tramo)
  end

  test "should destroy dt_tramo" do
    assert_difference("DtTramo.count", -1) do
      delete dt_tramo_url(@dt_tramo)
    end

    assert_redirected_to dt_tramos_url
  end
end
