require 'test_helper'

class OrgAreaAreasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @org_area_area = org_area_areas(:one)
  end

  test "should get index" do
    get org_area_areas_url
    assert_response :success
  end

  test "should get new" do
    get new_org_area_area_url
    assert_response :success
  end

  test "should create org_area_area" do
    assert_difference('OrgAreaArea.count') do
      post org_area_areas_url, params: { org_area_area: { child_id: @org_area_area.child_id, parent_id: @org_area_area.parent_id } }
    end

    assert_redirected_to org_area_area_url(OrgAreaArea.last)
  end

  test "should show org_area_area" do
    get org_area_area_url(@org_area_area)
    assert_response :success
  end

  test "should get edit" do
    get edit_org_area_area_url(@org_area_area)
    assert_response :success
  end

  test "should update org_area_area" do
    patch org_area_area_url(@org_area_area), params: { org_area_area: { child_id: @org_area_area.child_id, parent_id: @org_area_area.parent_id } }
    assert_redirected_to org_area_area_url(@org_area_area)
  end

  test "should destroy org_area_area" do
    assert_difference('OrgAreaArea.count', -1) do
      delete org_area_area_url(@org_area_area)
    end

    assert_redirected_to org_area_areas_url
  end
end
