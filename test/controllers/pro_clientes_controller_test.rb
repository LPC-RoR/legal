require "test_helper"

class ProClientesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pro_cliente = pro_clientes(:one)
  end

  test "should get index" do
    get pro_clientes_url
    assert_response :success
  end

  test "should get new" do
    get new_pro_cliente_url
    assert_response :success
  end

  test "should create pro_cliente" do
    assert_difference("ProCliente.count") do
      post pro_clientes_url, params: { pro_cliente: { cliente_id: @pro_cliente.cliente_id, producto_id: @pro_cliente.producto_id } }
    end

    assert_redirected_to pro_cliente_url(ProCliente.last)
  end

  test "should show pro_cliente" do
    get pro_cliente_url(@pro_cliente)
    assert_response :success
  end

  test "should get edit" do
    get edit_pro_cliente_url(@pro_cliente)
    assert_response :success
  end

  test "should update pro_cliente" do
    patch pro_cliente_url(@pro_cliente), params: { pro_cliente: { cliente_id: @pro_cliente.cliente_id, producto_id: @pro_cliente.producto_id } }
    assert_redirected_to pro_cliente_url(@pro_cliente)
  end

  test "should destroy pro_cliente" do
    assert_difference("ProCliente.count", -1) do
      delete pro_cliente_url(@pro_cliente)
    end

    assert_redirected_to pro_clientes_url
  end
end
