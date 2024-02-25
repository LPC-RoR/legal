require 'test_helper'

class TarDetCuantiaControlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tar_det_cuantia_control = tar_det_cuantia_controles(:one)
  end

  test "should get index" do
    get tar_det_cuantia_controles_url
    assert_response :success
  end

  test "should get new" do
    get new_tar_det_cuantia_control_url
    assert_response :success
  end

  test "should create tar_det_cuantia_control" do
    assert_difference('TarDetCuantiaControl.count') do
      post tar_det_cuantia_controles_url, params: { tar_det_cuantia_control: { control_documento_id: @tar_det_cuantia_control.control_documento_id, tar_detalle_cuantia_id: @tar_det_cuantia_control.tar_detalle_cuantia_id } }
    end

    assert_redirected_to tar_det_cuantia_control_url(TarDetCuantiaControl.last)
  end

  test "should show tar_det_cuantia_control" do
    get tar_det_cuantia_control_url(@tar_det_cuantia_control)
    assert_response :success
  end

  test "should get edit" do
    get edit_tar_det_cuantia_control_url(@tar_det_cuantia_control)
    assert_response :success
  end

  test "should update tar_det_cuantia_control" do
    patch tar_det_cuantia_control_url(@tar_det_cuantia_control), params: { tar_det_cuantia_control: { control_documento_id: @tar_det_cuantia_control.control_documento_id, tar_detalle_cuantia_id: @tar_det_cuantia_control.tar_detalle_cuantia_id } }
    assert_redirected_to tar_det_cuantia_control_url(@tar_det_cuantia_control)
  end

  test "should destroy tar_det_cuantia_control" do
    assert_difference('TarDetCuantiaControl.count', -1) do
      delete tar_det_cuantia_control_url(@tar_det_cuantia_control)
    end

    assert_redirected_to tar_det_cuantia_controles_url
  end
end
