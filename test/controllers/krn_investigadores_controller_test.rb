require "test_helper"

class KrnInvestigadoresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @krn_investigador = krn_investigadores(:one)
  end

  test "should get index" do
    get krn_investigadores_url
    assert_response :success
  end

  test "should get new" do
    get new_krn_investigador_url
    assert_response :success
  end

  test "should create krn_investigador" do
    assert_difference("KrnInvestigador.count") do
      post krn_investigadores_url, params: { krn_investigador: { email: @krn_investigador.email, krn_investigador: @krn_investigador.krn_investigador, rut: @krn_investigador.rut } }
    end

    assert_redirected_to krn_investigador_url(KrnInvestigador.last)
  end

  test "should show krn_investigador" do
    get krn_investigador_url(@krn_investigador)
    assert_response :success
  end

  test "should get edit" do
    get edit_krn_investigador_url(@krn_investigador)
    assert_response :success
  end

  test "should update krn_investigador" do
    patch krn_investigador_url(@krn_investigador), params: { krn_investigador: { email: @krn_investigador.email, krn_investigador: @krn_investigador.krn_investigador, rut: @krn_investigador.rut } }
    assert_redirected_to krn_investigador_url(@krn_investigador)
  end

  test "should destroy krn_investigador" do
    assert_difference("KrnInvestigador.count", -1) do
      delete krn_investigador_url(@krn_investigador)
    end

    assert_redirected_to krn_investigadores_url
  end
end
