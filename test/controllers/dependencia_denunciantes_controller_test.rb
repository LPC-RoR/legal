require "test_helper"

class DependenciaDenunciantesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @dependencia_denunciante = dependencia_denunciantes(:one)
  end

  test "should get index" do
    get dependencia_denunciantes_url
    assert_response :success
  end

  test "should get new" do
    get new_dependencia_denunciante_url
    assert_response :success
  end

  test "should create dependencia_denunciante" do
    assert_difference("DependenciaDenunciante.count") do
      post dependencia_denunciantes_url, params: { dependencia_denunciante: { dependencia_denunciante: @dependencia_denunciante.dependencia_denunciante } }
    end

    assert_redirected_to dependencia_denunciante_url(DependenciaDenunciante.last)
  end

  test "should show dependencia_denunciante" do
    get dependencia_denunciante_url(@dependencia_denunciante)
    assert_response :success
  end

  test "should get edit" do
    get edit_dependencia_denunciante_url(@dependencia_denunciante)
    assert_response :success
  end

  test "should update dependencia_denunciante" do
    patch dependencia_denunciante_url(@dependencia_denunciante), params: { dependencia_denunciante: { dependencia_denunciante: @dependencia_denunciante.dependencia_denunciante } }
    assert_redirected_to dependencia_denunciante_url(@dependencia_denunciante)
  end

  test "should destroy dependencia_denunciante" do
    assert_difference("DependenciaDenunciante.count", -1) do
      delete dependencia_denunciante_url(@dependencia_denunciante)
    end

    assert_redirected_to dependencia_denunciantes_url
  end
end
