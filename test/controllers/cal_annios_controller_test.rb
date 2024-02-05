require 'test_helper'

class CalAnniosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cal_annio = cal_annios(:one)
  end

  test "should get index" do
    get cal_annios_url
    assert_response :success
  end

  test "should get new" do
    get new_cal_annio_url
    assert_response :success
  end

  test "should create cal_annio" do
    assert_difference('CalAnnio.count') do
      post cal_annios_url, params: { cal_annio: { cal_annio: @cal_annio.cal_annio } }
    end

    assert_redirected_to cal_annio_url(CalAnnio.last)
  end

  test "should show cal_annio" do
    get cal_annio_url(@cal_annio)
    assert_response :success
  end

  test "should get edit" do
    get edit_cal_annio_url(@cal_annio)
    assert_response :success
  end

  test "should update cal_annio" do
    patch cal_annio_url(@cal_annio), params: { cal_annio: { cal_annio: @cal_annio.cal_annio } }
    assert_redirected_to cal_annio_url(@cal_annio)
  end

  test "should destroy cal_annio" do
    assert_difference('CalAnnio.count', -1) do
      delete cal_annio_url(@cal_annio)
    end

    assert_redirected_to cal_annios_url
  end
end
