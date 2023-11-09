require 'test_helper'

class OrgAreasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @org_area = org_areas(:one)
  end

  test "should get index" do
    get org_areas_url
    assert_response :success
  end

  test "should get new" do
    get new_org_area_url
    assert_response :success
  end

  test "should create org_area" do
    assert_difference('OrgArea.count') do
      post org_areas_url, params: { org_area: { org_area: @org_area.org_area } }
    end

    assert_redirected_to org_area_url(OrgArea.last)
  end

  test "should show org_area" do
    get org_area_url(@org_area)
    assert_response :success
  end

  test "should get edit" do
    get edit_org_area_url(@org_area)
    assert_response :success
  end

  test "should update org_area" do
    patch org_area_url(@org_area), params: { org_area: { org_area: @org_area.org_area } }
    assert_redirected_to org_area_url(@org_area)
  end

  test "should destroy org_area" do
    assert_difference('OrgArea.count', -1) do
      delete org_area_url(@org_area)
    end

    assert_redirected_to org_areas_url
  end
end
