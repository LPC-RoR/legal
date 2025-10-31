require "test_helper"

class ActTextosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @act_texto = act_textos(:one)
  end

  test "should get index" do
    get act_textos_url
    assert_response :success
  end

  test "should get new" do
    get new_act_texto_url
    assert_response :success
  end

  test "should create act_texto" do
    assert_difference("ActTexto.count") do
      post act_textos_url, params: { act_texto: { tipo_documento: @act_texto.tipo_documento } }
    end

    assert_redirected_to act_texto_url(ActTexto.last)
  end

  test "should show act_texto" do
    get act_texto_url(@act_texto)
    assert_response :success
  end

  test "should get edit" do
    get edit_act_texto_url(@act_texto)
    assert_response :success
  end

  test "should update act_texto" do
    patch act_texto_url(@act_texto), params: { act_texto: { tipo_documento: @act_texto.tipo_documento } }
    assert_redirected_to act_texto_url(@act_texto)
  end

  test "should destroy act_texto" do
    assert_difference("ActTexto.count", -1) do
      delete act_texto_url(@act_texto)
    end

    assert_redirected_to act_textos_url
  end
end
