require "test_helper"

class CliAprobacionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cli_aprobacion = cli_aprobaciones(:one)
  end

  test "should get index" do
    get cli_aprobaciones_url
    assert_response :success
  end

  test "should get new" do
    get new_cli_aprobacion_url
    assert_response :success
  end

  test "should create cli_aprobacion" do
    assert_difference("CliAprobacion.count") do
      post cli_aprobaciones_url, params: { cli_aprobacion: { fecha: @cli_aprobacion.fecha } }
    end

    assert_redirected_to cli_aprobacion_url(CliAprobacion.last)
  end

  test "should show cli_aprobacion" do
    get cli_aprobacion_url(@cli_aprobacion)
    assert_response :success
  end

  test "should get edit" do
    get edit_cli_aprobacion_url(@cli_aprobacion)
    assert_response :success
  end

  test "should update cli_aprobacion" do
    patch cli_aprobacion_url(@cli_aprobacion), params: { cli_aprobacion: { fecha: @cli_aprobacion.fecha } }
    assert_redirected_to cli_aprobacion_url(@cli_aprobacion)
  end

  test "should destroy cli_aprobacion" do
    assert_difference("CliAprobacion.count", -1) do
      delete cli_aprobacion_url(@cli_aprobacion)
    end

    assert_redirected_to cli_aprobaciones_url
  end
end
