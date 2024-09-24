require "test_helper"

class CtrEtapasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ctr_etapa = ctr_etapas(:one)
  end

  test "should get index" do
    get ctr_etapas_url
    assert_response :success
  end

  test "should get new" do
    get new_ctr_etapa_url
    assert_response :success
  end

  test "should create ctr_etapa" do
    assert_difference("CtrEtapa.count") do
      post ctr_etapas_url, params: { ctr_etapa: { codigo: @ctr_etapa.codigo, ctr_etapa: @ctr_etapa.ctr_etapa, procedimiento_id: @ctr_etapa.procedimiento_id } }
    end

    assert_redirected_to ctr_etapa_url(CtrEtapa.last)
  end

  test "should show ctr_etapa" do
    get ctr_etapa_url(@ctr_etapa)
    assert_response :success
  end

  test "should get edit" do
    get edit_ctr_etapa_url(@ctr_etapa)
    assert_response :success
  end

  test "should update ctr_etapa" do
    patch ctr_etapa_url(@ctr_etapa), params: { ctr_etapa: { codigo: @ctr_etapa.codigo, ctr_etapa: @ctr_etapa.ctr_etapa, procedimiento_id: @ctr_etapa.procedimiento_id } }
    assert_redirected_to ctr_etapa_url(@ctr_etapa)
  end

  test "should destroy ctr_etapa" do
    assert_difference("CtrEtapa.count", -1) do
      delete ctr_etapa_url(@ctr_etapa)
    end

    assert_redirected_to ctr_etapas_url
  end
end
