require "test_helper"

class HtextosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @htexto = htextos(:one)
  end

  test "should get index" do
    get htextos_url
    assert_response :success
  end

  test "should get new" do
    get new_htexto_url
    assert_response :success
  end

  test "should create htexto" do
    assert_difference("Htexto.count") do
      post htextos_url, params: { htexto: { h_texto: @htexto.h_texto, imagen: @htexto.imagen, img_sz: @htexto.img_sz, lnk: @htexto.lnk, lnk_txt: @htexto.lnk_txt, texto: @htexto.texto } }
    end

    assert_redirected_to htexto_url(Htexto.last)
  end

  test "should show htexto" do
    get htexto_url(@htexto)
    assert_response :success
  end

  test "should get edit" do
    get edit_htexto_url(@htexto)
    assert_response :success
  end

  test "should update htexto" do
    patch htexto_url(@htexto), params: { htexto: { h_texto: @htexto.h_texto, imagen: @htexto.imagen, img_sz: @htexto.img_sz, lnk: @htexto.lnk, lnk_txt: @htexto.lnk_txt, texto: @htexto.texto } }
    assert_redirected_to htexto_url(@htexto)
  end

  test "should destroy htexto" do
    assert_difference("Htexto.count", -1) do
      delete htexto_url(@htexto)
    end

    assert_redirected_to htextos_url
  end
end
