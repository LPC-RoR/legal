require "test_helper"

class LglDatosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lgl_dato = lgl_datos(:one)
  end

  test "should get index" do
    get lgl_datos_url
    assert_response :success
  end

  test "should get new" do
    get new_lgl_dato_url
    assert_response :success
  end

  test "should create lgl_dato" do
    assert_difference("LglDato.count") do
      post lgl_datos_url, params: { lgl_dato: { cita: @lgl_dato.cita, lgl_dato: @lgl_dato.lgl_dato, lgl_parrafo_id: @lgl_dato.lgl_parrafo_id, orden: @lgl_dato.orden } }
    end

    assert_redirected_to lgl_dato_url(LglDato.last)
  end

  test "should show lgl_dato" do
    get lgl_dato_url(@lgl_dato)
    assert_response :success
  end

  test "should get edit" do
    get edit_lgl_dato_url(@lgl_dato)
    assert_response :success
  end

  test "should update lgl_dato" do
    patch lgl_dato_url(@lgl_dato), params: { lgl_dato: { cita: @lgl_dato.cita, lgl_dato: @lgl_dato.lgl_dato, lgl_parrafo_id: @lgl_dato.lgl_parrafo_id, orden: @lgl_dato.orden } }
    assert_redirected_to lgl_dato_url(@lgl_dato)
  end

  test "should destroy lgl_dato" do
    assert_difference("LglDato.count", -1) do
      delete lgl_dato_url(@lgl_dato)
    end

    assert_redirected_to lgl_datos_url
  end
end
