require 'test_helper'

class OrgRegionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @org_region = org_regiones(:one)
  end

  test "should get index" do
    get org_regiones_url
    assert_response :success
  end

  test "should get new" do
    get new_org_region_url
    assert_response :success
  end

  test "should create org_region" do
    assert_difference('OrgRegion.count') do
      post org_regiones_url, params: { org_region: { orden: @org_region.orden, org_region: @org_region.org_region } }
    end

    assert_redirected_to org_region_url(OrgRegion.last)
  end

  test "should show org_region" do
    get org_region_url(@org_region)
    assert_response :success
  end

  test "should get edit" do
    get edit_org_region_url(@org_region)
    assert_response :success
  end

  test "should update org_region" do
    patch org_region_url(@org_region), params: { org_region: { orden: @org_region.orden, org_region: @org_region.org_region } }
    assert_redirected_to org_region_url(@org_region)
  end

  test "should destroy org_region" do
    assert_difference('OrgRegion.count', -1) do
      delete org_region_url(@org_region)
    end

    assert_redirected_to org_regiones_url
  end
end
