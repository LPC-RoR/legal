require "test_helper"

class HmParrafosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @hm_parrafo = hm_parrafos(:one)
  end

  test "should get index" do
    get hm_parrafos_url
    assert_response :success
  end

  test "should get new" do
    get new_hm_parrafo_url
    assert_response :success
  end

  test "should create hm_parrafo" do
    assert_difference("HmParrafo.count") do
      post hm_parrafos_url, params: { hm_parrafo: { hm_pagina_id: @hm_parrafo.hm_pagina_id, hm_parrafo: @hm_parrafo.hm_parrafo, imagen: @hm_parrafo.imagen, img_lyt: @hm_parrafo.img_lyt, orden: @hm_parrafo.orden, tipo: @hm_parrafo.tipo } }
    end

    assert_redirected_to hm_parrafo_url(HmParrafo.last)
  end

  test "should show hm_parrafo" do
    get hm_parrafo_url(@hm_parrafo)
    assert_response :success
  end

  test "should get edit" do
    get edit_hm_parrafo_url(@hm_parrafo)
    assert_response :success
  end

  test "should update hm_parrafo" do
    patch hm_parrafo_url(@hm_parrafo), params: { hm_parrafo: { hm_pagina_id: @hm_parrafo.hm_pagina_id, hm_parrafo: @hm_parrafo.hm_parrafo, imagen: @hm_parrafo.imagen, img_lyt: @hm_parrafo.img_lyt, orden: @hm_parrafo.orden, tipo: @hm_parrafo.tipo } }
    assert_redirected_to hm_parrafo_url(@hm_parrafo)
  end

  test "should destroy hm_parrafo" do
    assert_difference("HmParrafo.count", -1) do
      delete hm_parrafo_url(@hm_parrafo)
    end

    assert_redirected_to hm_parrafos_url
  end
end
