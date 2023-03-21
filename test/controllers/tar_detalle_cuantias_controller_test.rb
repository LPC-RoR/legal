require 'test_helper'

class TarDetalleCuantiasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tar_detalle_cuantia = tar_detalle_cuantias(:one)
  end

  test "should get index" do
    get tar_detalle_cuantias_url
    assert_response :success
  end

  test "should get new" do
    get new_tar_detalle_cuantia_url
    assert_response :success
  end

  test "should create tar_detalle_cuantia" do
    assert_difference('TarDetalleCuantia.count') do
      post tar_detalle_cuantias_url, params: { tar_detalle_cuantia: { tar_detalle_cuantia: @tar_detalle_cuantia.tar_detalle_cuantia } }
    end

    assert_redirected_to tar_detalle_cuantia_url(TarDetalleCuantia.last)
  end

  test "should show tar_detalle_cuantia" do
    get tar_detalle_cuantia_url(@tar_detalle_cuantia)
    assert_response :success
  end

  test "should get edit" do
    get edit_tar_detalle_cuantia_url(@tar_detalle_cuantia)
    assert_response :success
  end

  test "should update tar_detalle_cuantia" do
    patch tar_detalle_cuantia_url(@tar_detalle_cuantia), params: { tar_detalle_cuantia: { tar_detalle_cuantia: @tar_detalle_cuantia.tar_detalle_cuantia } }
    assert_redirected_to tar_detalle_cuantia_url(@tar_detalle_cuantia)
  end

  test "should destroy tar_detalle_cuantia" do
    assert_difference('TarDetalleCuantia.count', -1) do
      delete tar_detalle_cuantia_url(@tar_detalle_cuantia)
    end

    assert_redirected_to tar_detalle_cuantias_url
  end
end
