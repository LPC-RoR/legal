require "test_helper"

class HmNotasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @hm_nota = hm_notas(:one)
  end

  test "should get index" do
    get hm_notas_url
    assert_response :success
  end

  test "should get new" do
    get new_hm_nota_url
    assert_response :success
  end

  test "should create hm_nota" do
    assert_difference("HmNota.count") do
      post hm_notas_url, params: { hm_nota: { hm_nota: @hm_nota.hm_nota, hm_parrafo_id: @hm_nota.hm_parrafo_id, orden: @hm_nota.orden } }
    end

    assert_redirected_to hm_nota_url(HmNota.last)
  end

  test "should show hm_nota" do
    get hm_nota_url(@hm_nota)
    assert_response :success
  end

  test "should get edit" do
    get edit_hm_nota_url(@hm_nota)
    assert_response :success
  end

  test "should update hm_nota" do
    patch hm_nota_url(@hm_nota), params: { hm_nota: { hm_nota: @hm_nota.hm_nota, hm_parrafo_id: @hm_nota.hm_parrafo_id, orden: @hm_nota.orden } }
    assert_redirected_to hm_nota_url(@hm_nota)
  end

  test "should destroy hm_nota" do
    assert_difference("HmNota.count", -1) do
      delete hm_nota_url(@hm_nota)
    end

    assert_redirected_to hm_notas_url
  end
end
