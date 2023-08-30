require 'test_helper'

class DtMateriasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @dt_materia = dt_materias(:one)
  end

  test "should get index" do
    get dt_materias_url
    assert_response :success
  end

  test "should get new" do
    get new_dt_materia_url
    assert_response :success
  end

  test "should create dt_materia" do
    assert_difference('DtMateria.count') do
      post dt_materias_url, params: { dt_materia: { capitulo: @dt_materia.capitulo, dt_materia: @dt_materia.dt_materia } }
    end

    assert_redirected_to dt_materia_url(DtMateria.last)
  end

  test "should show dt_materia" do
    get dt_materia_url(@dt_materia)
    assert_response :success
  end

  test "should get edit" do
    get edit_dt_materia_url(@dt_materia)
    assert_response :success
  end

  test "should update dt_materia" do
    patch dt_materia_url(@dt_materia), params: { dt_materia: { capitulo: @dt_materia.capitulo, dt_materia: @dt_materia.dt_materia } }
    assert_redirected_to dt_materia_url(@dt_materia)
  end

  test "should destroy dt_materia" do
    assert_difference('DtMateria.count', -1) do
      delete dt_materia_url(@dt_materia)
    end

    assert_redirected_to dt_materias_url
  end
end
