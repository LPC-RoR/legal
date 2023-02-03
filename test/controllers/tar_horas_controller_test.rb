require 'test_helper'

class TarHorasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tar_hora = tar_horas(:one)
  end

  test "should get index" do
    get tar_horas_url
    assert_response :success
  end

  test "should get new" do
    get new_tar_hora_url
    assert_response :success
  end

  test "should create tar_hora" do
    assert_difference('TarHora.count') do
      post tar_horas_url, params: { tar_hora: { moneda: @tar_hora.moneda, owner_class: @tar_hora.owner_class, owner_id: @tar_hora.owner_id, tar_hora: @tar_hora.tar_hora, valor: @tar_hora.valor } }
    end

    assert_redirected_to tar_hora_url(TarHora.last)
  end

  test "should show tar_hora" do
    get tar_hora_url(@tar_hora)
    assert_response :success
  end

  test "should get edit" do
    get edit_tar_hora_url(@tar_hora)
    assert_response :success
  end

  test "should update tar_hora" do
    patch tar_hora_url(@tar_hora), params: { tar_hora: { moneda: @tar_hora.moneda, owner_class: @tar_hora.owner_class, owner_id: @tar_hora.owner_id, tar_hora: @tar_hora.tar_hora, valor: @tar_hora.valor } }
    assert_redirected_to tar_hora_url(@tar_hora)
  end

  test "should destroy tar_hora" do
    assert_difference('TarHora.count', -1) do
      delete tar_hora_url(@tar_hora)
    end

    assert_redirected_to tar_horas_url
  end
end
