require 'test_helper'

class PublicosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @publico = publicos(:one)
  end

  test "should get index" do
    get publicos_url
    assert_response :success
  end

  test "should get new" do
    get new_publico_url
    assert_response :success
  end

  test "should create publico" do
    assert_difference('Publico.count') do
      post publicos_url, params: { publico: {  } }
    end

    assert_redirected_to publico_url(Publico.last)
  end

  test "should show publico" do
    get publico_url(@publico)
    assert_response :success
  end

  test "should get edit" do
    get edit_publico_url(@publico)
    assert_response :success
  end

  test "should update publico" do
    patch publico_url(@publico), params: { publico: {  } }
    assert_redirected_to publico_url(@publico)
  end

  test "should destroy publico" do
    assert_difference('Publico.count', -1) do
      delete publico_url(@publico)
    end

    assert_redirected_to publicos_url
  end
end
