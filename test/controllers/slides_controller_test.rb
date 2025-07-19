require "test_helper"

class SlidesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @slid = slides(:one)
  end

  test "should get index" do
    get slides_url
    assert_response :success
  end

  test "should get new" do
    get new_slid_url
    assert_response :success
  end

  test "should create slid" do
    assert_difference("Slide.count") do
      post slides_url, params: { slid: { desactivar: @slid.desactivar, nombre: @slid.nombre, orden: @slid.orden, txt: @slid.txt } }
    end

    assert_redirected_to slid_url(Slide.last)
  end

  test "should show slid" do
    get slid_url(@slid)
    assert_response :success
  end

  test "should get edit" do
    get edit_slid_url(@slid)
    assert_response :success
  end

  test "should update slid" do
    patch slid_url(@slid), params: { slid: { desactivar: @slid.desactivar, nombre: @slid.nombre, orden: @slid.orden, txt: @slid.txt } }
    assert_redirected_to slid_url(@slid)
  end

  test "should destroy slid" do
    assert_difference("Slide.count", -1) do
      delete slid_url(@slid)
    end

    assert_redirected_to slides_url
  end
end
