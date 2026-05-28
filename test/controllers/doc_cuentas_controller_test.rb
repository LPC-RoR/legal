require "test_helper"

class DocCuentasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @doc_cuenta = doc_cuentas(:one)
  end

  test "should get index" do
    get doc_cuentas_url
    assert_response :success
  end

  test "should get new" do
    get new_doc_cuenta_url
    assert_response :success
  end

  test "should create doc_cuenta" do
    assert_difference("DocCuenta.count") do
      post doc_cuentas_url, params: { doc_cuenta: { sucursal: @doc_cuenta.sucursal } }
    end

    assert_redirected_to doc_cuenta_url(DocCuenta.last)
  end

  test "should show doc_cuenta" do
    get doc_cuenta_url(@doc_cuenta)
    assert_response :success
  end

  test "should get edit" do
    get edit_doc_cuenta_url(@doc_cuenta)
    assert_response :success
  end

  test "should update doc_cuenta" do
    patch doc_cuenta_url(@doc_cuenta), params: { doc_cuenta: { sucursal: @doc_cuenta.sucursal } }
    assert_redirected_to doc_cuenta_url(@doc_cuenta)
  end

  test "should destroy doc_cuenta" do
    assert_difference("DocCuenta.count", -1) do
      delete doc_cuenta_url(@doc_cuenta)
    end

    assert_redirected_to doc_cuentas_url
  end
end
