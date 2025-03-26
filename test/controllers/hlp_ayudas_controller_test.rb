require "test_helper"

class HlpAyudasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @hlp_ayuda = hlp_ayudas(:one)
  end

  test "should get index" do
    get hlp_ayudas_url
    assert_response :success
  end

  test "should get new" do
    get new_hlp_ayuda_url
    assert_response :success
  end

  test "should create hlp_ayuda" do
    assert_difference("HlpAyuda.count") do
      post hlp_ayudas_url, params: { hlp_ayuda: { hlp_ayuda: @hlp_ayuda.hlp_ayuda, ownr_id: @hlp_ayuda.ownr_id, ownr_type: @hlp_ayuda.ownr_type, referencia: @hlp_ayuda.referencia, texto: @hlp_ayuda.texto } }
    end

    assert_redirected_to hlp_ayuda_url(HlpAyuda.last)
  end

  test "should show hlp_ayuda" do
    get hlp_ayuda_url(@hlp_ayuda)
    assert_response :success
  end

  test "should get edit" do
    get edit_hlp_ayuda_url(@hlp_ayuda)
    assert_response :success
  end

  test "should update hlp_ayuda" do
    patch hlp_ayuda_url(@hlp_ayuda), params: { hlp_ayuda: { hlp_ayuda: @hlp_ayuda.hlp_ayuda, ownr_id: @hlp_ayuda.ownr_id, ownr_type: @hlp_ayuda.ownr_type, referencia: @hlp_ayuda.referencia, texto: @hlp_ayuda.texto } }
    assert_redirected_to hlp_ayuda_url(@hlp_ayuda)
  end

  test "should destroy hlp_ayuda" do
    assert_difference("HlpAyuda.count", -1) do
      delete hlp_ayuda_url(@hlp_ayuda)
    end

    assert_redirected_to hlp_ayudas_url
  end
end
