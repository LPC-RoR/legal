require "test_helper"

class HlpNotasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @hlp_nota = hlp_notas(:one)
  end

  test "should get index" do
    get hlp_notas_url
    assert_response :success
  end

  test "should get new" do
    get new_hlp_nota_url
    assert_response :success
  end

  test "should create hlp_nota" do
    assert_difference("HlpNota.count") do
      post hlp_notas_url, params: { hlp_nota: { hlp_nota: @hlp_nota.hlp_nota, orden: @hlp_nota.orden, ownr_id: @hlp_nota.ownr_id, ownr_type: @hlp_nota.ownr_type, referencia: @hlp_nota.referencia, texto: @hlp_nota.texto } }
    end

    assert_redirected_to hlp_nota_url(HlpNota.last)
  end

  test "should show hlp_nota" do
    get hlp_nota_url(@hlp_nota)
    assert_response :success
  end

  test "should get edit" do
    get edit_hlp_nota_url(@hlp_nota)
    assert_response :success
  end

  test "should update hlp_nota" do
    patch hlp_nota_url(@hlp_nota), params: { hlp_nota: { hlp_nota: @hlp_nota.hlp_nota, orden: @hlp_nota.orden, ownr_id: @hlp_nota.ownr_id, ownr_type: @hlp_nota.ownr_type, referencia: @hlp_nota.referencia, texto: @hlp_nota.texto } }
    assert_redirected_to hlp_nota_url(@hlp_nota)
  end

  test "should destroy hlp_nota" do
    assert_difference("HlpNota.count", -1) do
      delete hlp_nota_url(@hlp_nota)
    end

    assert_redirected_to hlp_notas_url
  end
end
