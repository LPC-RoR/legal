require "test_helper"

class CtrRegistrosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ctr_registro = ctr_registros(:one)
  end

  test "should get index" do
    get ctr_registros_url
    assert_response :success
  end

  test "should get new" do
    get new_ctr_registro_url
    assert_response :success
  end

  test "should create ctr_registro" do
    assert_difference("CtrRegistro.count") do
      post ctr_registros_url, params: { ctr_registro: { ctr_paso_id: @ctr_registro.ctr_paso_id, fecha: @ctr_registro.fecha, glosa: @ctr_registro.glosa, ownr_id: @ctr_registro.ownr_id, ownr_type: @ctr_registro.ownr_type, tarea_id: @ctr_registro.tarea_id, valor: @ctr_registro.valor } }
    end

    assert_redirected_to ctr_registro_url(CtrRegistro.last)
  end

  test "should show ctr_registro" do
    get ctr_registro_url(@ctr_registro)
    assert_response :success
  end

  test "should get edit" do
    get edit_ctr_registro_url(@ctr_registro)
    assert_response :success
  end

  test "should update ctr_registro" do
    patch ctr_registro_url(@ctr_registro), params: { ctr_registro: { ctr_paso_id: @ctr_registro.ctr_paso_id, fecha: @ctr_registro.fecha, glosa: @ctr_registro.glosa, ownr_id: @ctr_registro.ownr_id, ownr_type: @ctr_registro.ownr_type, tarea_id: @ctr_registro.tarea_id, valor: @ctr_registro.valor } }
    assert_redirected_to ctr_registro_url(@ctr_registro)
  end

  test "should destroy ctr_registro" do
    assert_difference("CtrRegistro.count", -1) do
      delete ctr_registro_url(@ctr_registro)
    end

    assert_redirected_to ctr_registros_url
  end
end
