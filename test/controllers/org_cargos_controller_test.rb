require 'test_helper'

class OrgCargosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @org_cargo = org_cargos(:one)
  end

  test "should get index" do
    get org_cargos_url
    assert_response :success
  end

  test "should get new" do
    get new_org_cargo_url
    assert_response :success
  end

  test "should create org_cargo" do
    assert_difference('OrgCargo.count') do
      post org_cargos_url, params: { org_cargo: { dotacion: @org_cargo.dotacion, org_area_id: @org_cargo.org_area_id, org_cargo: @org_cargo.org_cargo } }
    end

    assert_redirected_to org_cargo_url(OrgCargo.last)
  end

  test "should show org_cargo" do
    get org_cargo_url(@org_cargo)
    assert_response :success
  end

  test "should get edit" do
    get edit_org_cargo_url(@org_cargo)
    assert_response :success
  end

  test "should update org_cargo" do
    patch org_cargo_url(@org_cargo), params: { org_cargo: { dotacion: @org_cargo.dotacion, org_area_id: @org_cargo.org_area_id, org_cargo: @org_cargo.org_cargo } }
    assert_redirected_to org_cargo_url(@org_cargo)
  end

  test "should destroy org_cargo" do
    assert_difference('OrgCargo.count', -1) do
      delete org_cargo_url(@org_cargo)
    end

    assert_redirected_to org_cargos_url
  end
end
