require 'test_helper'

class AgeAntecedentesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @age_antecedente = age_antecedentes(:one)
  end

  test "should get index" do
    get age_antecedentes_url
    assert_response :success
  end

  test "should get new" do
    get new_age_antecedente_url
    assert_response :success
  end

  test "should create age_antecedente" do
    assert_difference('AgeAntecedente.count') do
      post age_antecedentes_url, params: { age_antecedente: { age_actividad_id: @age_antecedente.age_actividad_id, age_antecedente: @age_antecedente.age_antecedente, orden: @age_antecedente.orden } }
    end

    assert_redirected_to age_antecedente_url(AgeAntecedente.last)
  end

  test "should show age_antecedente" do
    get age_antecedente_url(@age_antecedente)
    assert_response :success
  end

  test "should get edit" do
    get edit_age_antecedente_url(@age_antecedente)
    assert_response :success
  end

  test "should update age_antecedente" do
    patch age_antecedente_url(@age_antecedente), params: { age_antecedente: { age_actividad_id: @age_antecedente.age_actividad_id, age_antecedente: @age_antecedente.age_antecedente, orden: @age_antecedente.orden } }
    assert_redirected_to age_antecedente_url(@age_antecedente)
  end

  test "should destroy age_antecedente" do
    assert_difference('AgeAntecedente.count', -1) do
      delete age_antecedente_url(@age_antecedente)
    end

    assert_redirected_to age_antecedentes_url
  end
end
