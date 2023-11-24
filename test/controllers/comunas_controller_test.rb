require 'test_helper'

class ComunasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @comuna = comunas(:one)
  end

  test "should get index" do
    get comunas_url
    assert_response :success
  end

  test "should get new" do
    get new_comuna_url
    assert_response :success
  end

  test "should create comuna" do
    assert_difference('Comuna.count') do
      post comunas_url, params: { comuna: { comuna: @comuna.comuna, region_id: @comuna.region_id } }
    end

    assert_redirected_to comuna_url(Comuna.last)
  end

  test "should show comuna" do
    get comuna_url(@comuna)
    assert_response :success
  end

  test "should get edit" do
    get edit_comuna_url(@comuna)
    assert_response :success
  end

  test "should update comuna" do
    patch comuna_url(@comuna), params: { comuna: { comuna: @comuna.comuna, region_id: @comuna.region_id } }
    assert_redirected_to comuna_url(@comuna)
  end

  test "should destroy comuna" do
    assert_difference('Comuna.count', -1) do
      delete comuna_url(@comuna)
    end

    assert_redirected_to comunas_url
  end
end
