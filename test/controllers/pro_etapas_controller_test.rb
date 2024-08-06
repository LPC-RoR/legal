require "test_helper"

class ProEtapasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pro_etapa = pro_etapas(:one)
  end

  test "should get index" do
    get pro_etapas_url
    assert_response :success
  end

  test "should get new" do
    get new_pro_etapa_url
    assert_response :success
  end

  test "should create pro_etapa" do
    assert_difference("ProEtapa.count") do
      post pro_etapas_url, params: { pro_etapa: { code_descripcion: @pro_etapa.code_descripcion, estado: @pro_etapa.estado, orden: @pro_etapa.orden, pro_etapa: @pro_etapa.pro_etapa, producto_id: @pro_etapa.producto_id } }
    end

    assert_redirected_to pro_etapa_url(ProEtapa.last)
  end

  test "should show pro_etapa" do
    get pro_etapa_url(@pro_etapa)
    assert_response :success
  end

  test "should get edit" do
    get edit_pro_etapa_url(@pro_etapa)
    assert_response :success
  end

  test "should update pro_etapa" do
    patch pro_etapa_url(@pro_etapa), params: { pro_etapa: { code_descripcion: @pro_etapa.code_descripcion, estado: @pro_etapa.estado, orden: @pro_etapa.orden, pro_etapa: @pro_etapa.pro_etapa, producto_id: @pro_etapa.producto_id } }
    assert_redirected_to pro_etapa_url(@pro_etapa)
  end

  test "should destroy pro_etapa" do
    assert_difference("ProEtapa.count", -1) do
      delete pro_etapa_url(@pro_etapa)
    end

    assert_redirected_to pro_etapas_url
  end
end
