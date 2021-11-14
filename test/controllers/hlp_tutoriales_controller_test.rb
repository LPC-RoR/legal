require 'test_helper'

class HlpTutorialesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @hlp_tutorial = hlp_tutoriales(:one)
  end

  test "should get index" do
    get hlp_tutoriales_url
    assert_response :success
  end

  test "should get new" do
    get new_hlp_tutorial_url
    assert_response :success
  end

  test "should create hlp_tutorial" do
    assert_difference('HlpTutorial.count') do
      post hlp_tutoriales_url, params: { hlp_tutorial: { clave: @hlp_tutorial.clave, detalle: @hlp_tutorial.detalle, tutorial: @hlp_tutorial.tutorial } }
    end

    assert_redirected_to hlp_tutorial_url(HlpTutorial.last)
  end

  test "should show hlp_tutorial" do
    get hlp_tutorial_url(@hlp_tutorial)
    assert_response :success
  end

  test "should get edit" do
    get edit_hlp_tutorial_url(@hlp_tutorial)
    assert_response :success
  end

  test "should update hlp_tutorial" do
    patch hlp_tutorial_url(@hlp_tutorial), params: { hlp_tutorial: { clave: @hlp_tutorial.clave, detalle: @hlp_tutorial.detalle, tutorial: @hlp_tutorial.tutorial } }
    assert_redirected_to hlp_tutorial_url(@hlp_tutorial)
  end

  test "should destroy hlp_tutorial" do
    assert_difference('HlpTutorial.count', -1) do
      delete hlp_tutorial_url(@hlp_tutorial)
    end

    assert_redirected_to hlp_tutoriales_url
  end
end
