require 'test_helper'

class HlpPasosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @hlp_paso = hlp_pasos(:one)
  end

  test "should get index" do
    get hlp_pasos_url
    assert_response :success
  end

  test "should get new" do
    get new_hlp_paso_url
    assert_response :success
  end

  test "should create hlp_paso" do
    assert_difference('HlpPaso.count') do
      post hlp_pasos_url, params: { hlp_paso: { detalle: @hlp_paso.detalle, hlp_tutorial_id: @hlp_paso.hlp_tutorial_id, orden: @hlp_paso.orden, paso: @hlp_paso.paso } }
    end

    assert_redirected_to hlp_paso_url(HlpPaso.last)
  end

  test "should show hlp_paso" do
    get hlp_paso_url(@hlp_paso)
    assert_response :success
  end

  test "should get edit" do
    get edit_hlp_paso_url(@hlp_paso)
    assert_response :success
  end

  test "should update hlp_paso" do
    patch hlp_paso_url(@hlp_paso), params: { hlp_paso: { detalle: @hlp_paso.detalle, hlp_tutorial_id: @hlp_paso.hlp_tutorial_id, orden: @hlp_paso.orden, paso: @hlp_paso.paso } }
    assert_redirected_to hlp_paso_url(@hlp_paso)
  end

  test "should destroy hlp_paso" do
    assert_difference('HlpPaso.count', -1) do
      delete hlp_paso_url(@hlp_paso)
    end

    assert_redirected_to hlp_pasos_url
  end
end
