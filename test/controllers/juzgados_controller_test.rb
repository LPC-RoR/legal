require 'test_helper'

class JuzgadosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @juzgado = juzgados(:one)
  end

  test "should get index" do
    get juzgados_url
    assert_response :success
  end

  test "should get new" do
    get new_juzgado_url
    assert_response :success
  end

  test "should create juzgado" do
    assert_difference('Juzgado.count') do
      post juzgados_url, params: { juzgado: { juzgado: @juzgado.juzgado } }
    end

    assert_redirected_to juzgado_url(Juzgado.last)
  end

  test "should show juzgado" do
    get juzgado_url(@juzgado)
    assert_response :success
  end

  test "should get edit" do
    get edit_juzgado_url(@juzgado)
    assert_response :success
  end

  test "should update juzgado" do
    patch juzgado_url(@juzgado), params: { juzgado: { juzgado: @juzgado.juzgado } }
    assert_redirected_to juzgado_url(@juzgado)
  end

  test "should destroy juzgado" do
    assert_difference('Juzgado.count', -1) do
      delete juzgado_url(@juzgado)
    end

    assert_redirected_to juzgados_url
  end
end
