require "test_helper"

class TxtEditablesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @txt_editable = txt_editables(:one)
  end

  test "should get index" do
    get txt_editables_url
    assert_response :success
  end

  test "should get new" do
    get new_txt_editable_url
    assert_response :success
  end

  test "should create txt_editable" do
    assert_difference("TxtEditable.count") do
      post txt_editables_url, params: { txt_editable: { codigo: @txt_editable.codigo, ownr_id: @txt_editable.ownr_id, ownr_type: @txt_editable.ownr_type, titulo: @txt_editable.titulo } }
    end

    assert_redirected_to txt_editable_url(TxtEditable.last)
  end

  test "should show txt_editable" do
    get txt_editable_url(@txt_editable)
    assert_response :success
  end

  test "should get edit" do
    get edit_txt_editable_url(@txt_editable)
    assert_response :success
  end

  test "should update txt_editable" do
    patch txt_editable_url(@txt_editable), params: { txt_editable: { codigo: @txt_editable.codigo, ownr_id: @txt_editable.ownr_id, ownr_type: @txt_editable.ownr_type, titulo: @txt_editable.titulo } }
    assert_redirected_to txt_editable_url(@txt_editable)
  end

  test "should destroy txt_editable" do
    assert_difference("TxtEditable.count", -1) do
      delete txt_editable_url(@txt_editable)
    end

    assert_redirected_to txt_editables_url
  end
end
