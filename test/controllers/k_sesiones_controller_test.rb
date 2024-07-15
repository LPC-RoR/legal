require "test_helper"

class KSesionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @k_sesion = k_sesiones(:one)
  end

  test "should get index" do
    get k_sesiones_url
    assert_response :success
  end

  test "should get new" do
    get new_k_sesion_url
    assert_response :success
  end

  test "should create k_sesion" do
    assert_difference("KSesion.count") do
      post k_sesiones_url, params: { k_sesion: { fecha: @k_sesion.fecha, sesion: @k_sesion.sesion } }
    end

    assert_redirected_to k_sesion_url(KSesion.last)
  end

  test "should show k_sesion" do
    get k_sesion_url(@k_sesion)
    assert_response :success
  end

  test "should get edit" do
    get edit_k_sesion_url(@k_sesion)
    assert_response :success
  end

  test "should update k_sesion" do
    patch k_sesion_url(@k_sesion), params: { k_sesion: { fecha: @k_sesion.fecha, sesion: @k_sesion.sesion } }
    assert_redirected_to k_sesion_url(@k_sesion)
  end

  test "should destroy k_sesion" do
    assert_difference("KSesion.count", -1) do
      delete k_sesion_url(@k_sesion)
    end

    assert_redirected_to k_sesiones_url
  end
end
