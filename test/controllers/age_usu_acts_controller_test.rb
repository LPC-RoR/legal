require 'test_helper'

class AgeUsuActsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @age_usu_act = age_usu_acts(:one)
  end

  test "should get index" do
    get age_usu_acts_url
    assert_response :success
  end

  test "should get new" do
    get new_age_usu_act_url
    assert_response :success
  end

  test "should create age_usu_act" do
    assert_difference('AgeUsuAct.count') do
      post age_usu_acts_url, params: { age_usu_act: { age_actividad_id: @age_usu_act.age_actividad_id, age_usuario_id: @age_usu_act.age_usuario_id } }
    end

    assert_redirected_to age_usu_act_url(AgeUsuAct.last)
  end

  test "should show age_usu_act" do
    get age_usu_act_url(@age_usu_act)
    assert_response :success
  end

  test "should get edit" do
    get edit_age_usu_act_url(@age_usu_act)
    assert_response :success
  end

  test "should update age_usu_act" do
    patch age_usu_act_url(@age_usu_act), params: { age_usu_act: { age_actividad_id: @age_usu_act.age_actividad_id, age_usuario_id: @age_usu_act.age_usuario_id } }
    assert_redirected_to age_usu_act_url(@age_usu_act)
  end

  test "should destroy age_usu_act" do
    assert_difference('AgeUsuAct.count', -1) do
      delete age_usu_act_url(@age_usu_act)
    end

    assert_redirected_to age_usu_acts_url
  end
end
