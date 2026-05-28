require "test_helper"

class ProveedoresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @proveedor = proveedores(:one)
  end

  test "should get index" do
    get proveedores_url
    assert_response :success
  end

  test "should get new" do
    get new_proveedor_url
    assert_response :success
  end

  test "should create proveedor" do
    assert_difference("Proveedor.count") do
      post proveedores_url, params: { proveedor: { razon_social: @proveedor.razon_social, rut: @proveedor.rut } }
    end

    assert_redirected_to proveedor_url(Proveedor.last)
  end

  test "should show proveedor" do
    get proveedor_url(@proveedor)
    assert_response :success
  end

  test "should get edit" do
    get edit_proveedor_url(@proveedor)
    assert_response :success
  end

  test "should update proveedor" do
    patch proveedor_url(@proveedor), params: { proveedor: { razon_social: @proveedor.razon_social, rut: @proveedor.rut } }
    assert_redirected_to proveedor_url(@proveedor)
  end

  test "should destroy proveedor" do
    assert_difference("Proveedor.count", -1) do
      delete proveedor_url(@proveedor)
    end

    assert_redirected_to proveedores_url
  end
end
