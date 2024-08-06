require "test_helper"

class ProNominasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pro_nomina = pro_nominas(:one)
  end

  test "should get index" do
    get pro_nominas_url
    assert_response :success
  end

  test "should get new" do
    get new_pro_nomina_url
    assert_response :success
  end

  test "should create pro_nomina" do
    assert_difference("ProNomina.count") do
      post pro_nominas_url, params: { pro_nomina: { app_nomina_id: @pro_nomina.app_nomina_id, producto_id: @pro_nomina.producto_id } }
    end

    assert_redirected_to pro_nomina_url(ProNomina.last)
  end

  test "should show pro_nomina" do
    get pro_nomina_url(@pro_nomina)
    assert_response :success
  end

  test "should get edit" do
    get edit_pro_nomina_url(@pro_nomina)
    assert_response :success
  end

  test "should update pro_nomina" do
    patch pro_nomina_url(@pro_nomina), params: { pro_nomina: { app_nomina_id: @pro_nomina.app_nomina_id, producto_id: @pro_nomina.producto_id } }
    assert_redirected_to pro_nomina_url(@pro_nomina)
  end

  test "should destroy pro_nomina" do
    assert_difference("ProNomina.count", -1) do
      delete pro_nomina_url(@pro_nomina)
    end

    assert_redirected_to pro_nominas_url
  end
end
