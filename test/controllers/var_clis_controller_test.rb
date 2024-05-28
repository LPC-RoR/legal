require 'test_helper'

class VarClisControllerTest < ActionDispatch::IntegrationTest
  setup do
    @var_cli = var_clis(:one)
  end

  test "should get index" do
    get var_clis_url
    assert_response :success
  end

  test "should get new" do
    get new_var_cli_url
    assert_response :success
  end

  test "should create var_cli" do
    assert_difference('VarCli.count') do
      post var_clis_url, params: { var_cli: { cliente_id: @var_cli.cliente_id, variable_id: @var_cli.variable_id } }
    end

    assert_redirected_to var_cli_url(VarCli.last)
  end

  test "should show var_cli" do
    get var_cli_url(@var_cli)
    assert_response :success
  end

  test "should get edit" do
    get edit_var_cli_url(@var_cli)
    assert_response :success
  end

  test "should update var_cli" do
    patch var_cli_url(@var_cli), params: { var_cli: { cliente_id: @var_cli.cliente_id, variable_id: @var_cli.variable_id } }
    assert_redirected_to var_cli_url(@var_cli)
  end

  test "should destroy var_cli" do
    assert_difference('VarCli.count', -1) do
      delete var_cli_url(@var_cli)
    end

    assert_redirected_to var_clis_url
  end
end
