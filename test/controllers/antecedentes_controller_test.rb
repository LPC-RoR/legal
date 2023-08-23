require 'test_helper'

class AntecedentesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @antecedente = antecedentes(:one)
  end

  test "should get index" do
    get antecedentes_url
    assert_response :success
  end

  test "should get new" do
    get new_antecedente_url
    assert_response :success
  end

  test "should create antecedente" do
    assert_difference('Antecedente.count') do
      post antecedentes_url, params: { antecedente: { causa_id: @antecedente.causa_id, cita: @antecedente.cita, hecho: @antecedente.hecho, orden: @antecedente.orden, riesgo: @antecedente.riesgo, ventaja: @antecedente.ventaja } }
    end

    assert_redirected_to antecedente_url(Antecedente.last)
  end

  test "should show antecedente" do
    get antecedente_url(@antecedente)
    assert_response :success
  end

  test "should get edit" do
    get edit_antecedente_url(@antecedente)
    assert_response :success
  end

  test "should update antecedente" do
    patch antecedente_url(@antecedente), params: { antecedente: { causa_id: @antecedente.causa_id, cita: @antecedente.cita, hecho: @antecedente.hecho, orden: @antecedente.orden, riesgo: @antecedente.riesgo, ventaja: @antecedente.ventaja } }
    assert_redirected_to antecedente_url(@antecedente)
  end

  test "should destroy antecedente" do
    assert_difference('Antecedente.count', -1) do
      delete antecedente_url(@antecedente)
    end

    assert_redirected_to antecedentes_url
  end
end
