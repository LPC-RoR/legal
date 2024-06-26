require "test_helper"

class ParrafosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @parrafo = parrafos(:one)
  end

  test "should get index" do
    get parrafos_url
    assert_response :success
  end

  test "should get new" do
    get new_parrafo_url
    assert_response :success
  end

  test "should create parrafo" do
    assert_difference("Parrafo.count") do
      post parrafos_url, params: { parrafo: { causa_id: @parrafo.causa_id, orden: @parrafo.orden, seccion_id: @parrafo.seccion_id, texto: @parrafo.texto } }
    end

    assert_redirected_to parrafo_url(Parrafo.last)
  end

  test "should show parrafo" do
    get parrafo_url(@parrafo)
    assert_response :success
  end

  test "should get edit" do
    get edit_parrafo_url(@parrafo)
    assert_response :success
  end

  test "should update parrafo" do
    patch parrafo_url(@parrafo), params: { parrafo: { causa_id: @parrafo.causa_id, orden: @parrafo.orden, seccion_id: @parrafo.seccion_id, texto: @parrafo.texto } }
    assert_redirected_to parrafo_url(@parrafo)
  end

  test "should destroy parrafo" do
    assert_difference("Parrafo.count", -1) do
      delete parrafo_url(@parrafo)
    end

    assert_redirected_to parrafos_url
  end
end
