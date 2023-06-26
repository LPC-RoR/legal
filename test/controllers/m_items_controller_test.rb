require 'test_helper'

class MItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_item = m_items(:one)
  end

  test "should get index" do
    get m_items_url
    assert_response :success
  end

  test "should get new" do
    get new_m_item_url
    assert_response :success
  end

  test "should create m_item" do
    assert_difference('MItem.count') do
      post m_items_url, params: { m_item: { m_item: @m_item.m_item, orden: @m_item.orden } }
    end

    assert_redirected_to m_item_url(MItem.last)
  end

  test "should show m_item" do
    get m_item_url(@m_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_item_url(@m_item)
    assert_response :success
  end

  test "should update m_item" do
    patch m_item_url(@m_item), params: { m_item: { m_item: @m_item.m_item, orden: @m_item.orden } }
    assert_redirected_to m_item_url(@m_item)
  end

  test "should destroy m_item" do
    assert_difference('MItem.count', -1) do
      delete m_item_url(@m_item)
    end

    assert_redirected_to m_items_url
  end
end
