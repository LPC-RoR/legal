require 'test_helper'

class TarTarifasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tar_tarifa = tar_tarifas(:one)
  end

  test "should get index" do
    get tar_tarifas_url
    assert_response :success
  end

  test "should get new" do
    get new_tar_tarifa_url
    assert_response :success
  end

  test "should create tar_tarifa" do
    assert_difference('TarTarifa.count') do
      post tar_tarifas_url, params: { tar_tarifa: { estado: @tar_tarifa.estado, owner_class: @tar_tarifa.owner_class, owner_id: @tar_tarifa.owner_id, tarifa: @tar_tarifa.tarifa } }
    end

    assert_redirected_to tar_tarifa_url(TarTarifa.last)
  end

  test "should show tar_tarifa" do
    get tar_tarifa_url(@tar_tarifa)
    assert_response :success
  end

  test "should get edit" do
    get edit_tar_tarifa_url(@tar_tarifa)
    assert_response :success
  end

  test "should update tar_tarifa" do
    patch tar_tarifa_url(@tar_tarifa), params: { tar_tarifa: { estado: @tar_tarifa.estado, owner_class: @tar_tarifa.owner_class, owner_id: @tar_tarifa.owner_id, tarifa: @tar_tarifa.tarifa } }
    assert_redirected_to tar_tarifa_url(@tar_tarifa)
  end

  test "should destroy tar_tarifa" do
    assert_difference('TarTarifa.count', -1) do
      delete tar_tarifa_url(@tar_tarifa)
    end

    assert_redirected_to tar_tarifas_url
  end
end
