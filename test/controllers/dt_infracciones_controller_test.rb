require 'test_helper'

class DtInfraccionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @dt_infraccion = dt_infracciones(:one)
  end

  test "should get index" do
    get dt_infracciones_url
    assert_response :success
  end

  test "should get new" do
    get new_dt_infraccion_url
    assert_response :success
  end

  test "should create dt_infraccion" do
    assert_difference('DtInfraccion.count') do
      post dt_infracciones_url, params: { dt_infraccion: { codigo: @dt_infraccion.codigo, criterios: @dt_infraccion.criterios, dt_infraccion: @dt_infraccion.dt_infraccion, dt_materia_id: @dt_infraccion.dt_materia_id, normas: @dt_infraccion.normas, tipificacion: @dt_infraccion.tipificacion } }
    end

    assert_redirected_to dt_infraccion_url(DtInfraccion.last)
  end

  test "should show dt_infraccion" do
    get dt_infraccion_url(@dt_infraccion)
    assert_response :success
  end

  test "should get edit" do
    get edit_dt_infraccion_url(@dt_infraccion)
    assert_response :success
  end

  test "should update dt_infraccion" do
    patch dt_infraccion_url(@dt_infraccion), params: { dt_infraccion: { codigo: @dt_infraccion.codigo, criterios: @dt_infraccion.criterios, dt_infraccion: @dt_infraccion.dt_infraccion, dt_materia_id: @dt_infraccion.dt_materia_id, normas: @dt_infraccion.normas, tipificacion: @dt_infraccion.tipificacion } }
    assert_redirected_to dt_infraccion_url(@dt_infraccion)
  end

  test "should destroy dt_infraccion" do
    assert_difference('DtInfraccion.count', -1) do
      delete dt_infraccion_url(@dt_infraccion)
    end

    assert_redirected_to dt_infracciones_url
  end
end
