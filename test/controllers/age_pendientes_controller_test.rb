require 'test_helper'

class AgePendientesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @age_pendiente = age_pendientes(:one)
  end

  test "should get index" do
    get age_pendientes_url
    assert_response :success
  end

  test "should get new" do
    get new_age_pendiente_url
    assert_response :success
  end

  test "should create age_pendiente" do
    assert_difference('AgePendiente.count') do
      post age_pendientes_url, params: { age_pendiente: { age_pendiente: @age_pendiente.age_pendiente, age_usuario_id: @age_pendiente.age_usuario_id, estado: @age_pendiente.estado, prioridad: @age_pendiente.prioridad } }
    end

    assert_redirected_to age_pendiente_url(AgePendiente.last)
  end

  test "should show age_pendiente" do
    get age_pendiente_url(@age_pendiente)
    assert_response :success
  end

  test "should get edit" do
    get edit_age_pendiente_url(@age_pendiente)
    assert_response :success
  end

  test "should update age_pendiente" do
    patch age_pendiente_url(@age_pendiente), params: { age_pendiente: { age_pendiente: @age_pendiente.age_pendiente, age_usuario_id: @age_pendiente.age_usuario_id, estado: @age_pendiente.estado, prioridad: @age_pendiente.prioridad } }
    assert_redirected_to age_pendiente_url(@age_pendiente)
  end

  test "should destroy age_pendiente" do
    assert_difference('AgePendiente.count', -1) do
      delete age_pendiente_url(@age_pendiente)
    end

    assert_redirected_to age_pendientes_url
  end
end
