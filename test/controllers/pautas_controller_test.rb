require "test_helper"

class PautasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pauta = pautas(:one)
  end

  test "should get index" do
    get pautas_url
    assert_response :success
  end

  test "should get new" do
    get new_pauta_url
    assert_response :success
  end

  test "should create pauta" do
    assert_difference("Pauta.count") do
      post pautas_url, params: { pauta: { orden: @pauta.orden, pauta: @pauta.pauta, referencia: @pauta.referencia } }
    end

    assert_redirected_to pauta_url(Pauta.last)
  end

  test "should show pauta" do
    get pauta_url(@pauta)
    assert_response :success
  end

  test "should get edit" do
    get edit_pauta_url(@pauta)
    assert_response :success
  end

  test "should update pauta" do
    patch pauta_url(@pauta), params: { pauta: { orden: @pauta.orden, pauta: @pauta.pauta, referencia: @pauta.referencia } }
    assert_redirected_to pauta_url(@pauta)
  end

  test "should destroy pauta" do
    assert_difference("Pauta.count", -1) do
      delete pauta_url(@pauta)
    end

    assert_redirected_to pautas_url
  end
end
