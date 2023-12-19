require 'test_helper'

class ValoresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @valor = valores(:one)
  end

  test "should get index" do
    get valores_url
    assert_response :success
  end

  test "should get new" do
    get new_valor_url
    assert_response :success
  end

  test "should create valor" do
    assert_difference('Valor.count') do
      post valores_url, params: { valor: { c_fecha: @valor.c_fecha, c_numero: @valor.c_numero, c_string: @valor.c_string, c_text: @valor.c_text, owner_class: @valor.owner_class, owner_id: @valor.owner_id, variable_id: @valor.variable_id } }
    end

    assert_redirected_to valor_url(Valor.last)
  end

  test "should show valor" do
    get valor_url(@valor)
    assert_response :success
  end

  test "should get edit" do
    get edit_valor_url(@valor)
    assert_response :success
  end

  test "should update valor" do
    patch valor_url(@valor), params: { valor: { c_fecha: @valor.c_fecha, c_numero: @valor.c_numero, c_string: @valor.c_string, c_text: @valor.c_text, owner_class: @valor.owner_class, owner_id: @valor.owner_id, variable_id: @valor.variable_id } }
    assert_redirected_to valor_url(@valor)
  end

  test "should destroy valor" do
    assert_difference('Valor.count', -1) do
      delete valor_url(@valor)
    end

    assert_redirected_to valores_url
  end
end
