require "test_helper"

class LglEntidadesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lgl_entidad = lgl_entidades(:one)
  end

  test "should get index" do
    get lgl_entidades_url
    assert_response :success
  end

  test "should get new" do
    get new_lgl_entidad_url
    assert_response :success
  end

  test "should create lgl_entidad" do
    assert_difference("LglEntidad.count") do
      post lgl_entidades_url, params: { lgl_entidad: { dependencia: @lgl_entidad.dependencia, lgl_entidad: @lgl_entidad.lgl_entidad, tipo: @lgl_entidad.tipo } }
    end

    assert_redirected_to lgl_entidad_url(LglEntidad.last)
  end

  test "should show lgl_entidad" do
    get lgl_entidad_url(@lgl_entidad)
    assert_response :success
  end

  test "should get edit" do
    get edit_lgl_entidad_url(@lgl_entidad)
    assert_response :success
  end

  test "should update lgl_entidad" do
    patch lgl_entidad_url(@lgl_entidad), params: { lgl_entidad: { dependencia: @lgl_entidad.dependencia, lgl_entidad: @lgl_entidad.lgl_entidad, tipo: @lgl_entidad.tipo } }
    assert_redirected_to lgl_entidad_url(@lgl_entidad)
  end

  test "should destroy lgl_entidad" do
    assert_difference("LglEntidad.count", -1) do
      delete lgl_entidad_url(@lgl_entidad)
    end

    assert_redirected_to lgl_entidades_url
  end
end
