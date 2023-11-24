require 'test_helper'

class OrgSucursalesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @org_sucursal = org_sucursales(:one)
  end

  test "should get index" do
    get org_sucursales_url
    assert_response :success
  end

  test "should get new" do
    get new_org_sucursal_url
    assert_response :success
  end

  test "should create org_sucursal" do
    assert_difference('OrgSucursal.count') do
      post org_sucursales_url, params: { org_sucursal: { direccion: @org_sucursal.direccion, org_sucursal: @org_sucursal.org_sucursal } }
    end

    assert_redirected_to org_sucursal_url(OrgSucursal.last)
  end

  test "should show org_sucursal" do
    get org_sucursal_url(@org_sucursal)
    assert_response :success
  end

  test "should get edit" do
    get edit_org_sucursal_url(@org_sucursal)
    assert_response :success
  end

  test "should update org_sucursal" do
    patch org_sucursal_url(@org_sucursal), params: { org_sucursal: { direccion: @org_sucursal.direccion, org_sucursal: @org_sucursal.org_sucursal } }
    assert_redirected_to org_sucursal_url(@org_sucursal)
  end

  test "should destroy org_sucursal" do
    assert_difference('OrgSucursal.count', -1) do
      delete org_sucursal_url(@org_sucursal)
    end

    assert_redirected_to org_sucursales_url
  end
end
