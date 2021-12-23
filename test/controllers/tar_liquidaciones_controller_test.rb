require 'test_helper'

class TarLiquidacionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tar_liquidacion = tar_liquidaciones(:one)
  end

  test "should get index" do
    get tar_liquidaciones_url
    assert_response :success
  end

  test "should get new" do
    get new_tar_liquidacion_url
    assert_response :success
  end

  test "should create tar_liquidacion" do
    assert_difference('TarLiquidacion.count') do
      post tar_liquidaciones_url, params: { tar_liquidacion: { liquidacion: @tar_liquidacion.liquidacion, owner_class: @tar_liquidacion.owner_class, owner_id: @tar_liquidacion.owner_id } }
    end

    assert_redirected_to tar_liquidacion_url(TarLiquidacion.last)
  end

  test "should show tar_liquidacion" do
    get tar_liquidacion_url(@tar_liquidacion)
    assert_response :success
  end

  test "should get edit" do
    get edit_tar_liquidacion_url(@tar_liquidacion)
    assert_response :success
  end

  test "should update tar_liquidacion" do
    patch tar_liquidacion_url(@tar_liquidacion), params: { tar_liquidacion: { liquidacion: @tar_liquidacion.liquidacion, owner_class: @tar_liquidacion.owner_class, owner_id: @tar_liquidacion.owner_id } }
    assert_redirected_to tar_liquidacion_url(@tar_liquidacion)
  end

  test "should destroy tar_liquidacion" do
    assert_difference('TarLiquidacion.count', -1) do
      delete tar_liquidacion_url(@tar_liquidacion)
    end

    assert_redirected_to tar_liquidaciones_url
  end
end
