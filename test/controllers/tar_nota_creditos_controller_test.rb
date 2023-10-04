require 'test_helper'

class TarNotaCreditosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tar_nota_credito = tar_nota_creditos(:one)
  end

  test "should get index" do
    get tar_nota_creditos_url
    assert_response :success
  end

  test "should get new" do
    get new_tar_nota_credito_url
    assert_response :success
  end

  test "should create tar_nota_credito" do
    assert_difference('TarNotaCredito.count') do
      post tar_nota_creditos_url, params: { tar_nota_credito: { fecha: @tar_nota_credito.fecha, monto: @tar_nota_credito.monto, monto_total: @tar_nota_credito.monto_total, numero: @tar_nota_credito.numero, tar_factura_id: @tar_nota_credito.tar_factura_id } }
    end

    assert_redirected_to tar_nota_credito_url(TarNotaCredito.last)
  end

  test "should show tar_nota_credito" do
    get tar_nota_credito_url(@tar_nota_credito)
    assert_response :success
  end

  test "should get edit" do
    get edit_tar_nota_credito_url(@tar_nota_credito)
    assert_response :success
  end

  test "should update tar_nota_credito" do
    patch tar_nota_credito_url(@tar_nota_credito), params: { tar_nota_credito: { fecha: @tar_nota_credito.fecha, monto: @tar_nota_credito.monto, monto_total: @tar_nota_credito.monto_total, numero: @tar_nota_credito.numero, tar_factura_id: @tar_nota_credito.tar_factura_id } }
    assert_redirected_to tar_nota_credito_url(@tar_nota_credito)
  end

  test "should destroy tar_nota_credito" do
    assert_difference('TarNotaCredito.count', -1) do
      delete tar_nota_credito_url(@tar_nota_credito)
    end

    assert_redirected_to tar_nota_creditos_url
  end
end
