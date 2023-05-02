require 'test_helper'

class TribunalCortesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tribunal_corte = tribunal_cortes(:one)
  end

  test "should get index" do
    get tribunal_cortes_url
    assert_response :success
  end

  test "should get new" do
    get new_tribunal_corte_url
    assert_response :success
  end

  test "should create tribunal_corte" do
    assert_difference('TribunalCorte.count') do
      post tribunal_cortes_url, params: { tribunal_corte: { tribunal_corte: @tribunal_corte.tribunal_corte } }
    end

    assert_redirected_to tribunal_corte_url(TribunalCorte.last)
  end

  test "should show tribunal_corte" do
    get tribunal_corte_url(@tribunal_corte)
    assert_response :success
  end

  test "should get edit" do
    get edit_tribunal_corte_url(@tribunal_corte)
    assert_response :success
  end

  test "should update tribunal_corte" do
    patch tribunal_corte_url(@tribunal_corte), params: { tribunal_corte: { tribunal_corte: @tribunal_corte.tribunal_corte } }
    assert_redirected_to tribunal_corte_url(@tribunal_corte)
  end

  test "should destroy tribunal_corte" do
    assert_difference('TribunalCorte.count', -1) do
      delete tribunal_corte_url(@tribunal_corte)
    end

    assert_redirected_to tribunal_cortes_url
  end
end
