require "test_helper"

class RespuestasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @respuesta = respuestas(:one)
  end

  test "should get index" do
    get respuestas_url
    assert_response :success
  end

  test "should get new" do
    get new_respuesta_url
    assert_response :success
  end

  test "should create respuesta" do
    assert_difference("Respuesta.count") do
      post respuestas_url, params: { respuesta: { campania_id: @respuesta.campania_id, propuesta: @respuesta.propuesta, respuesta: @respuesta.respuesta, sesion_id: @respuesta.sesion_id } }
    end

    assert_redirected_to respuesta_url(Respuesta.last)
  end

  test "should show respuesta" do
    get respuesta_url(@respuesta)
    assert_response :success
  end

  test "should get edit" do
    get edit_respuesta_url(@respuesta)
    assert_response :success
  end

  test "should update respuesta" do
    patch respuesta_url(@respuesta), params: { respuesta: { campania_id: @respuesta.campania_id, propuesta: @respuesta.propuesta, respuesta: @respuesta.respuesta, sesion_id: @respuesta.sesion_id } }
    assert_redirected_to respuesta_url(@respuesta)
  end

  test "should destroy respuesta" do
    assert_difference("Respuesta.count", -1) do
      delete respuesta_url(@respuesta)
    end

    assert_redirected_to respuestas_url
  end
end
