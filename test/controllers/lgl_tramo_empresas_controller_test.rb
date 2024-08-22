require "test_helper"

class LglTramoEmpresasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lgl_tramo_empresa = lgl_tramo_empresas(:one)
  end

  test "should get index" do
    get lgl_tramo_empresas_url
    assert_response :success
  end

  test "should get new" do
    get new_lgl_tramo_empresa_url
    assert_response :success
  end

  test "should create lgl_tramo_empresa" do
    assert_difference("LglTramoEmpresa.count") do
      post lgl_tramo_empresas_url, params: { lgl_tramo_empresa: { lgl_tramo_empresa: @lgl_tramo_empresa.lgl_tramo_empresa, max: @lgl_tramo_empresa.max, min: @lgl_tramo_empresa.min } }
    end

    assert_redirected_to lgl_tramo_empresa_url(LglTramoEmpresa.last)
  end

  test "should show lgl_tramo_empresa" do
    get lgl_tramo_empresa_url(@lgl_tramo_empresa)
    assert_response :success
  end

  test "should get edit" do
    get edit_lgl_tramo_empresa_url(@lgl_tramo_empresa)
    assert_response :success
  end

  test "should update lgl_tramo_empresa" do
    patch lgl_tramo_empresa_url(@lgl_tramo_empresa), params: { lgl_tramo_empresa: { lgl_tramo_empresa: @lgl_tramo_empresa.lgl_tramo_empresa, max: @lgl_tramo_empresa.max, min: @lgl_tramo_empresa.min } }
    assert_redirected_to lgl_tramo_empresa_url(@lgl_tramo_empresa)
  end

  test "should destroy lgl_tramo_empresa" do
    assert_difference("LglTramoEmpresa.count", -1) do
      delete lgl_tramo_empresa_url(@lgl_tramo_empresa)
    end

    assert_redirected_to lgl_tramo_empresas_url
  end
end
