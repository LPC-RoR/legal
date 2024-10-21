require "test_helper"

class CuentasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cuenta = cuentas(:one)
  end

  test "should get index" do
    get cuentas_url
    assert_response :success
  end

  test "should get new" do
    get new_cuenta_url
    assert_response :success
  end

  test "should create cuenta" do
    assert_difference("Cuenta.count") do
      post cuentas_url, params: { cuenta: {  } }
    end

    assert_redirected_to cuenta_url(Cuenta.last)
  end

  test "should show cuenta" do
    get cuenta_url(@cuenta)
    assert_response :success
  end

  test "should get edit" do
    get edit_cuenta_url(@cuenta)
    assert_response :success
  end

  test "should update cuenta" do
    patch cuenta_url(@cuenta), params: { cuenta: {  } }
    assert_redirected_to cuenta_url(@cuenta)
  end

  test "should destroy cuenta" do
    assert_difference("Cuenta.count", -1) do
      delete cuenta_url(@cuenta)
    end

    assert_redirected_to cuentas_url
  end
end
