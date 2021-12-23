require 'test_helper'

class TarBasesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tar_bas = tar_bases(:one)
  end

  test "should get index" do
    get tar_bases_url
    assert_response :success
  end

  test "should get new" do
    get new_tar_bas_url
    assert_response :success
  end

  test "should create tar_bas" do
    assert_difference('TarBase.count') do
      post tar_bases_url, params: { tar_bas: { monto: @tar_bas.monto, monto_uf: @tar_bas.monto_uf, owner_class: @tar_bas.owner_class, owner_id: @tar_bas.owner_id, perfil_id: @tar_bas.perfil_id } }
    end

    assert_redirected_to tar_bas_url(TarBase.last)
  end

  test "should show tar_bas" do
    get tar_bas_url(@tar_bas)
    assert_response :success
  end

  test "should get edit" do
    get edit_tar_bas_url(@tar_bas)
    assert_response :success
  end

  test "should update tar_bas" do
    patch tar_bas_url(@tar_bas), params: { tar_bas: { monto: @tar_bas.monto, monto_uf: @tar_bas.monto_uf, owner_class: @tar_bas.owner_class, owner_id: @tar_bas.owner_id, perfil_id: @tar_bas.perfil_id } }
    assert_redirected_to tar_bas_url(@tar_bas)
  end

  test "should destroy tar_bas" do
    assert_difference('TarBase.count', -1) do
      delete tar_bas_url(@tar_bas)
    end

    assert_redirected_to tar_bases_url
  end
end
