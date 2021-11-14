require 'test_helper'

class StBandejasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @st_bandeja = st_bandejas(:one)
  end

  test "should get index" do
    get st_bandejas_url
    assert_response :success
  end

  test "should get new" do
    get new_st_bandeja_url
    assert_response :success
  end

  test "should create st_bandeja" do
    assert_difference('StBandeja.count') do
      post st_bandejas_url, params: { st_bandeja: {  } }
    end

    assert_redirected_to st_bandeja_url(StBandeja.last)
  end

  test "should show st_bandeja" do
    get st_bandeja_url(@st_bandeja)
    assert_response :success
  end

  test "should get edit" do
    get edit_st_bandeja_url(@st_bandeja)
    assert_response :success
  end

  test "should update st_bandeja" do
    patch st_bandeja_url(@st_bandeja), params: { st_bandeja: {  } }
    assert_redirected_to st_bandeja_url(@st_bandeja)
  end

  test "should destroy st_bandeja" do
    assert_difference('StBandeja.count', -1) do
      delete st_bandeja_url(@st_bandeja)
    end

    assert_redirected_to st_bandejas_url
  end
end
