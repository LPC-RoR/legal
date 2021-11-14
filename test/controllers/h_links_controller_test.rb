require 'test_helper'

class HLinksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @h_link = h_links(:one)
  end

  test "should get index" do
    get h_links_url
    assert_response :success
  end

  test "should get new" do
    get new_h_link_url
    assert_response :success
  end

  test "should create h_link" do
    assert_difference('HLink.count') do
      post h_links_url, params: { h_link: { link: @h_link.link, texto: @h_link.texto } }
    end

    assert_redirected_to h_link_url(HLink.last)
  end

  test "should show h_link" do
    get h_link_url(@h_link)
    assert_response :success
  end

  test "should get edit" do
    get edit_h_link_url(@h_link)
    assert_response :success
  end

  test "should update h_link" do
    patch h_link_url(@h_link), params: { h_link: { link: @h_link.link, texto: @h_link.texto } }
    assert_redirected_to h_link_url(@h_link)
  end

  test "should destroy h_link" do
    assert_difference('HLink.count', -1) do
      delete h_link_url(@h_link)
    end

    assert_redirected_to h_links_url
  end
end
