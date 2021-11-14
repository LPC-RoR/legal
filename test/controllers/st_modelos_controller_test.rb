require 'test_helper'

class StModelosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @st_modelo = st_modelos(:one)
  end

  test "should get index" do
    get st_modelos_url
    assert_response :success
  end

  test "should get new" do
    get new_st_modelo_url
    assert_response :success
  end

  test "should create st_modelo" do
    assert_difference('StModelo.count') do
      post st_modelos_url, params: { st_modelo: { st_modelo: @st_modelo.st_modelo } }
    end

    assert_redirected_to st_modelo_url(StModelo.last)
  end

  test "should show st_modelo" do
    get st_modelo_url(@st_modelo)
    assert_response :success
  end

  test "should get edit" do
    get edit_st_modelo_url(@st_modelo)
    assert_response :success
  end

  test "should update st_modelo" do
    patch st_modelo_url(@st_modelo), params: { st_modelo: { st_modelo: @st_modelo.st_modelo } }
    assert_redirected_to st_modelo_url(@st_modelo)
  end

  test "should destroy st_modelo" do
    assert_difference('StModelo.count', -1) do
      delete st_modelo_url(@st_modelo)
    end

    assert_redirected_to st_modelos_url
  end
end
