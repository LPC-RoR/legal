require 'test_helper'

class TarConveniosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tar_convenio = tar_convenios(:one)
  end

  test "should get index" do
    get tar_convenios_url
    assert_response :success
  end

  test "should get new" do
    get new_tar_convenio_url
    assert_response :success
  end

  test "should create tar_convenio" do
    assert_difference('TarConvenio.count') do
      post tar_convenios_url, params: { tar_convenio: { estado: @tar_convenio.estado, fecha: @tar_convenio.fecha, monto: @tar_convenio.monto, tar_factura_id: @tar_convenio.tar_factura_id } }
    end

    assert_redirected_to tar_convenio_url(TarConvenio.last)
  end

  test "should show tar_convenio" do
    get tar_convenio_url(@tar_convenio)
    assert_response :success
  end

  test "should get edit" do
    get edit_tar_convenio_url(@tar_convenio)
    assert_response :success
  end

  test "should update tar_convenio" do
    patch tar_convenio_url(@tar_convenio), params: { tar_convenio: { estado: @tar_convenio.estado, fecha: @tar_convenio.fecha, monto: @tar_convenio.monto, tar_factura_id: @tar_convenio.tar_factura_id } }
    assert_redirected_to tar_convenio_url(@tar_convenio)
  end

  test "should destroy tar_convenio" do
    assert_difference('TarConvenio.count', -1) do
      delete tar_convenio_url(@tar_convenio)
    end

    assert_redirected_to tar_convenios_url
  end
end
