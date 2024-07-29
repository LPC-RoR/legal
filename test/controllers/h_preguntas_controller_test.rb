require "test_helper"

class HPreguntasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @h_pregunta = h_preguntas(:one)
  end

  test "should get index" do
    get h_preguntas_url
    assert_response :success
  end

  test "should get new" do
    get new_h_pregunta_url
    assert_response :success
  end

  test "should create h_pregunta" do
    assert_difference("HPregunta.count") do
      post h_preguntas_url, params: { h_pregunta: { h_pregunta: @h_pregunta.h_pregunta, lnk: @h_pregunta.lnk, lnk_txt: @h_pregunta.lnk_txt, respuesta: @h_pregunta.respuesta } }
    end

    assert_redirected_to h_pregunta_url(HPregunta.last)
  end

  test "should show h_pregunta" do
    get h_pregunta_url(@h_pregunta)
    assert_response :success
  end

  test "should get edit" do
    get edit_h_pregunta_url(@h_pregunta)
    assert_response :success
  end

  test "should update h_pregunta" do
    patch h_pregunta_url(@h_pregunta), params: { h_pregunta: { h_pregunta: @h_pregunta.h_pregunta, lnk: @h_pregunta.lnk, lnk_txt: @h_pregunta.lnk_txt, respuesta: @h_pregunta.respuesta } }
    assert_redirected_to h_pregunta_url(@h_pregunta)
  end

  test "should destroy h_pregunta" do
    assert_difference("HPregunta.count", -1) do
      delete h_pregunta_url(@h_pregunta)
    end

    assert_redirected_to h_preguntas_url
  end
end
