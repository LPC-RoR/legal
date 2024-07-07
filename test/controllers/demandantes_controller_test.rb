require "test_helper"

class DemandantesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @demandante = demandantes(:one)
  end

  test "should get index" do
    get demandantes_url
    assert_response :success
  end

  test "should get new" do
    get new_demandante_url
    assert_response :success
  end

  test "should create demandante" do
    assert_difference("Demandante.count") do
      post demandantes_url, params: { demandante: { apellidos: @demandante.apellidos, cargo: @demandante.cargo, causa_id: @demandante.causa_id, lugar_trabajo: @demandante.lugar_trabajo, nombres: @demandante.nombres, orden: @demandante.orden, remuneracion: @demandante.remuneracion } }
    end

    assert_redirected_to demandante_url(Demandante.last)
  end

  test "should show demandante" do
    get demandante_url(@demandante)
    assert_response :success
  end

  test "should get edit" do
    get edit_demandante_url(@demandante)
    assert_response :success
  end

  test "should update demandante" do
    patch demandante_url(@demandante), params: { demandante: { apellidos: @demandante.apellidos, cargo: @demandante.cargo, causa_id: @demandante.causa_id, lugar_trabajo: @demandante.lugar_trabajo, nombres: @demandante.nombres, orden: @demandante.orden, remuneracion: @demandante.remuneracion } }
    assert_redirected_to demandante_url(@demandante)
  end

  test "should destroy demandante" do
    assert_difference("Demandante.count", -1) do
      delete demandante_url(@demandante)
    end

    assert_redirected_to demandantes_url
  end
end
