require "test_helper"

class HmPaginasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @hm_pagina = hm_paginas(:one)
  end

  test "should get index" do
    get hm_paginas_url
    assert_response :success
  end

  test "should get new" do
    get new_hm_pagina_url
    assert_response :success
  end

  test "should create hm_pagina" do
    assert_difference("HmPagina.count") do
      post hm_paginas_url, params: { hm_pagina: { codigo: @hm_pagina.codigo, hm_pagina: @hm_pagina.hm_pagina, ownr_clss: @hm_pagina.ownr_clss, ownr_id: @hm_pagina.ownr_id, tooltip: @hm_pagina.tooltip } }
    end

    assert_redirected_to hm_pagina_url(HmPagina.last)
  end

  test "should show hm_pagina" do
    get hm_pagina_url(@hm_pagina)
    assert_response :success
  end

  test "should get edit" do
    get edit_hm_pagina_url(@hm_pagina)
    assert_response :success
  end

  test "should update hm_pagina" do
    patch hm_pagina_url(@hm_pagina), params: { hm_pagina: { codigo: @hm_pagina.codigo, hm_pagina: @hm_pagina.hm_pagina, ownr_clss: @hm_pagina.ownr_clss, ownr_id: @hm_pagina.ownr_id, tooltip: @hm_pagina.tooltip } }
    assert_redirected_to hm_pagina_url(@hm_pagina)
  end

  test "should destroy hm_pagina" do
    assert_difference("HmPagina.count", -1) do
      delete hm_pagina_url(@hm_pagina)
    end

    assert_redirected_to hm_paginas_url
  end
end
