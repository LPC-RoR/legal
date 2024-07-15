require "test_helper"

class CuestionariosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cuestionario = cuestionarios(:one)
  end

  test "should get index" do
    get cuestionarios_url
    assert_response :success
  end

  test "should get new" do
    get new_cuestionario_url
    assert_response :success
  end

  test "should create cuestionario" do
    assert_difference("Cuestionario.count") do
      post cuestionarios_url, params: { cuestionario: { cuestionario: @cuestionario.cuestionario, orden: @cuestionario.orden, pauta_id: @cuestionario.pauta_id, referencia: @cuestionario.referencia } }
    end

    assert_redirected_to cuestionario_url(Cuestionario.last)
  end

  test "should show cuestionario" do
    get cuestionario_url(@cuestionario)
    assert_response :success
  end

  test "should get edit" do
    get edit_cuestionario_url(@cuestionario)
    assert_response :success
  end

  test "should update cuestionario" do
    patch cuestionario_url(@cuestionario), params: { cuestionario: { cuestionario: @cuestionario.cuestionario, orden: @cuestionario.orden, pauta_id: @cuestionario.pauta_id, referencia: @cuestionario.referencia } }
    assert_redirected_to cuestionario_url(@cuestionario)
  end

  test "should destroy cuestionario" do
    assert_difference("Cuestionario.count", -1) do
      delete cuestionario_url(@cuestionario)
    end

    assert_redirected_to cuestionarios_url
  end
end
