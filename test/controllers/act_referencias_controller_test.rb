require "test_helper"

class ActReferenciasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @act_referencia = act_referencias(:one)
  end

  test "should get index" do
    get act_referencias_url
    assert_response :success
  end

  test "should get new" do
    get new_act_referencia_url
    assert_response :success
  end

  test "should create act_referencia" do
    assert_difference("ActReferencia.count") do
      post act_referencias_url, params: { act_referencia: { act_archivo_id: @act_referencia.act_archivo_id, ref_id: @act_referencia.ref_id, ref_type: @act_referencia.ref_type } }
    end

    assert_redirected_to act_referencia_url(ActReferencia.last)
  end

  test "should show act_referencia" do
    get act_referencia_url(@act_referencia)
    assert_response :success
  end

  test "should get edit" do
    get edit_act_referencia_url(@act_referencia)
    assert_response :success
  end

  test "should update act_referencia" do
    patch act_referencia_url(@act_referencia), params: { act_referencia: { act_archivo_id: @act_referencia.act_archivo_id, ref_id: @act_referencia.ref_id, ref_type: @act_referencia.ref_type } }
    assert_redirected_to act_referencia_url(@act_referencia)
  end

  test "should destroy act_referencia" do
    assert_difference("ActReferencia.count", -1) do
      delete act_referencia_url(@act_referencia)
    end

    assert_redirected_to act_referencias_url
  end
end
