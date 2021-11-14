require 'test_helper'

class HTemasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @h_tema = h_temas(:one)
  end

  test "should get index" do
    get h_temas_url
    assert_response :success
  end

  test "should get new" do
    get new_h_tema_url
    assert_response :success
  end

  test "should create h_tema" do
    assert_difference('HTema.count') do
      post h_temas_url, params: { h_tema: { detalle: @h_tema.detalle, tema: @h_tema.tema } }
    end

    assert_redirected_to h_tema_url(HTema.last)
  end

  test "should show h_tema" do
    get h_tema_url(@h_tema)
    assert_response :success
  end

  test "should get edit" do
    get edit_h_tema_url(@h_tema)
    assert_response :success
  end

  test "should update h_tema" do
    patch h_tema_url(@h_tema), params: { h_tema: { detalle: @h_tema.detalle, tema: @h_tema.tema } }
    assert_redirected_to h_tema_url(@h_tema)
  end

  test "should destroy h_tema" do
    assert_difference('HTema.count', -1) do
      delete h_tema_url(@h_tema)
    end

    assert_redirected_to h_temas_url
  end
end
