require "test_helper"

class LglTipoEntidadesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lgl_tipo_entidad = lgl_tipo_entidades(:one)
  end

  test "should get index" do
    get lgl_tipo_entidades_url
    assert_response :success
  end

  test "should get new" do
    get new_lgl_tipo_entidad_url
    assert_response :success
  end

  test "should create lgl_tipo_entidad" do
    assert_difference("LglTipoEntidad.count") do
      post lgl_tipo_entidades_url, params: { lgl_tipo_entidad: { lgl_tipo_entidad: @lgl_tipo_entidad.lgl_tipo_entidad } }
    end

    assert_redirected_to lgl_tipo_entidad_url(LglTipoEntidad.last)
  end

  test "should show lgl_tipo_entidad" do
    get lgl_tipo_entidad_url(@lgl_tipo_entidad)
    assert_response :success
  end

  test "should get edit" do
    get edit_lgl_tipo_entidad_url(@lgl_tipo_entidad)
    assert_response :success
  end

  test "should update lgl_tipo_entidad" do
    patch lgl_tipo_entidad_url(@lgl_tipo_entidad), params: { lgl_tipo_entidad: { lgl_tipo_entidad: @lgl_tipo_entidad.lgl_tipo_entidad } }
    assert_redirected_to lgl_tipo_entidad_url(@lgl_tipo_entidad)
  end

  test "should destroy lgl_tipo_entidad" do
    assert_difference("LglTipoEntidad.count", -1) do
      delete lgl_tipo_entidad_url(@lgl_tipo_entidad)
    end

    assert_redirected_to lgl_tipo_entidades_url
  end
end
