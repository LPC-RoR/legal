require "test_helper"

class HmLinksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @hm_link = hm_links(:one)
  end

  test "should get index" do
    get hm_links_url
    assert_response :success
  end

  test "should get new" do
    get new_hm_link_url
    assert_response :success
  end

  test "should create hm_link" do
    assert_difference("HmLink.count") do
      post hm_links_url, params: { hm_link: { hm_link: @hm_link.hm_link, hm_parrafo_id: @hm_link.hm_parrafo_id, orden: @hm_link.orden, texto: @hm_link.texto } }
    end

    assert_redirected_to hm_link_url(HmLink.last)
  end

  test "should show hm_link" do
    get hm_link_url(@hm_link)
    assert_response :success
  end

  test "should get edit" do
    get edit_hm_link_url(@hm_link)
    assert_response :success
  end

  test "should update hm_link" do
    patch hm_link_url(@hm_link), params: { hm_link: { hm_link: @hm_link.hm_link, hm_parrafo_id: @hm_link.hm_parrafo_id, orden: @hm_link.orden, texto: @hm_link.texto } }
    assert_redirected_to hm_link_url(@hm_link)
  end

  test "should destroy hm_link" do
    assert_difference("HmLink.count", -1) do
      delete hm_link_url(@hm_link)
    end

    assert_redirected_to hm_links_url
  end
end
