require 'test_helper'

class HechosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @hecho = hechos(:one)
  end

  test "should get index" do
    get hechos_url
    assert_response :success
  end

  test "should get new" do
    get new_hecho_url
    assert_response :success
  end

  test "should create hecho" do
    assert_difference('Hecho.count') do
      post hechos_url, params: { hecho: { archivo: @hecho.archivo, cita: @hecho.cita, hecho: @hecho.hecho, orden: @hecho.orden, tema_id: @hecho.tema_id } }
    end

    assert_redirected_to hecho_url(Hecho.last)
  end

  test "should show hecho" do
    get hecho_url(@hecho)
    assert_response :success
  end

  test "should get edit" do
    get edit_hecho_url(@hecho)
    assert_response :success
  end

  test "should update hecho" do
    patch hecho_url(@hecho), params: { hecho: { archivo: @hecho.archivo, cita: @hecho.cita, hecho: @hecho.hecho, orden: @hecho.orden, tema_id: @hecho.tema_id } }
    assert_redirected_to hecho_url(@hecho)
  end

  test "should destroy hecho" do
    assert_difference('Hecho.count', -1) do
      delete hecho_url(@hecho)
    end

    assert_redirected_to hechos_url
  end
end
