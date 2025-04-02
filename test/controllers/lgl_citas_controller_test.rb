require "test_helper"

class LglCitasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lgl_cita = lgl_citas(:one)
  end

  test "should get index" do
    get lgl_citas_url
    assert_response :success
  end

  test "should get new" do
    get new_lgl_cita_url
    assert_response :success
  end

  test "should create lgl_cita" do
    assert_difference("LglCita.count") do
      post lgl_citas_url, params: { lgl_cita: { codigo: @lgl_cita.codigo, lgl_cita: @lgl_cita.lgl_cita, lgl_parrafo_id: @lgl_cita.lgl_parrafo_id, orden: @lgl_cita.orden, referencia: @lgl_cita.referencia } }
    end

    assert_redirected_to lgl_cita_url(LglCita.last)
  end

  test "should show lgl_cita" do
    get lgl_cita_url(@lgl_cita)
    assert_response :success
  end

  test "should get edit" do
    get edit_lgl_cita_url(@lgl_cita)
    assert_response :success
  end

  test "should update lgl_cita" do
    patch lgl_cita_url(@lgl_cita), params: { lgl_cita: { codigo: @lgl_cita.codigo, lgl_cita: @lgl_cita.lgl_cita, lgl_parrafo_id: @lgl_cita.lgl_parrafo_id, orden: @lgl_cita.orden, referencia: @lgl_cita.referencia } }
    assert_redirected_to lgl_cita_url(@lgl_cita)
  end

  test "should destroy lgl_cita" do
    assert_difference("LglCita.count", -1) do
      delete lgl_cita_url(@lgl_cita)
    end

    assert_redirected_to lgl_citas_url
  end
end
