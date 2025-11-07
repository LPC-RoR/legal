require "test_helper"

class ActMetadatasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @act_metadata = act_metadatas(:one)
  end

  test "should get index" do
    get act_metadatas_url
    assert_response :success
  end

  test "should get new" do
    get new_act_metadata_url
    assert_response :success
  end

  test "should create act_metadata" do
    assert_difference("ActMetadata.count") do
      post act_metadatas_url, params: { act_metadata: { act_metadata: @act_metadata.act_metadata } }
    end

    assert_redirected_to act_metadata_url(ActMetadata.last)
  end

  test "should show act_metadata" do
    get act_metadata_url(@act_metadata)
    assert_response :success
  end

  test "should get edit" do
    get edit_act_metadata_url(@act_metadata)
    assert_response :success
  end

  test "should update act_metadata" do
    patch act_metadata_url(@act_metadata), params: { act_metadata: { act_metadata: @act_metadata.act_metadata } }
    assert_redirected_to act_metadata_url(@act_metadata)
  end

  test "should destroy act_metadata" do
    assert_difference("ActMetadata.count", -1) do
      delete act_metadata_url(@act_metadata)
    end

    assert_redirected_to act_metadatas_url
  end
end
