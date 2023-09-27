require 'test_helper'

class TablasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tabla = tablas(:one)
  end

  test "should get index" do
    get tablas_url
    assert_response :success
  end

  test "should get new" do
    get new_tabla_url
    assert_response :success
  end

  test "should create tabla" do
    assert_difference('Tabla.count') do
      post tablas_url, params: { tabla: {  } }
    end

    assert_redirected_to tabla_url(Tabla.last)
  end

  test "should show tabla" do
    get tabla_url(@tabla)
    assert_response :success
  end

  test "should get edit" do
    get edit_tabla_url(@tabla)
    assert_response :success
  end

  test "should update tabla" do
    patch tabla_url(@tabla), params: { tabla: {  } }
    assert_redirected_to tabla_url(@tabla)
  end

  test "should destroy tabla" do
    assert_difference('Tabla.count', -1) do
      delete tabla_url(@tabla)
    end

    assert_redirected_to tablas_url
  end
end
