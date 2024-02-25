require 'test_helper'

class CausaHechosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @causa_hecho = causa_hechos(:one)
  end

  test "should get index" do
    get causa_hechos_url
    assert_response :success
  end

  test "should get new" do
    get new_causa_hecho_url
    assert_response :success
  end

  test "should create causa_hecho" do
    assert_difference('CausaHecho.count') do
      post causa_hechos_url, params: { causa_hecho: { causa_id: @causa_hecho.causa_id, hecho_id: @causa_hecho.hecho_id, orden: @causa_hecho.orden, st_contestación: @causa_hecho.st_contestación, st_juicio: @causa_hecho.st_juicio, st_preparatoria: @causa_hecho.st_preparatoria } }
    end

    assert_redirected_to causa_hecho_url(CausaHecho.last)
  end

  test "should show causa_hecho" do
    get causa_hecho_url(@causa_hecho)
    assert_response :success
  end

  test "should get edit" do
    get edit_causa_hecho_url(@causa_hecho)
    assert_response :success
  end

  test "should update causa_hecho" do
    patch causa_hecho_url(@causa_hecho), params: { causa_hecho: { causa_id: @causa_hecho.causa_id, hecho_id: @causa_hecho.hecho_id, orden: @causa_hecho.orden, st_contestación: @causa_hecho.st_contestación, st_juicio: @causa_hecho.st_juicio, st_preparatoria: @causa_hecho.st_preparatoria } }
    assert_redirected_to causa_hecho_url(@causa_hecho)
  end

  test "should destroy causa_hecho" do
    assert_difference('CausaHecho.count', -1) do
      delete causa_hecho_url(@causa_hecho)
    end

    assert_redirected_to causa_hechos_url
  end
end
