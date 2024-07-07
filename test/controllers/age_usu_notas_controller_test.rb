require "test_helper"

class AgeUsuNotasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @age_usu_nota = age_usu_notas(:one)
  end

  test "should get index" do
    get age_usu_notas_url
    assert_response :success
  end

  test "should get new" do
    get new_age_usu_nota_url
    assert_response :success
  end

  test "should create age_usu_nota" do
    assert_difference("AgeUsuNota.count") do
      post age_usu_notas_url, params: { age_usu_nota: { age_usuario_id: @age_usu_nota.age_usuario_id, nota_id: @age_usu_nota.nota_id } }
    end

    assert_redirected_to age_usu_nota_url(AgeUsuNota.last)
  end

  test "should show age_usu_nota" do
    get age_usu_nota_url(@age_usu_nota)
    assert_response :success
  end

  test "should get edit" do
    get edit_age_usu_nota_url(@age_usu_nota)
    assert_response :success
  end

  test "should update age_usu_nota" do
    patch age_usu_nota_url(@age_usu_nota), params: { age_usu_nota: { age_usuario_id: @age_usu_nota.age_usuario_id, nota_id: @age_usu_nota.nota_id } }
    assert_redirected_to age_usu_nota_url(@age_usu_nota)
  end

  test "should destroy age_usu_nota" do
    assert_difference("AgeUsuNota.count", -1) do
      delete age_usu_nota_url(@age_usu_nota)
    end

    assert_redirected_to age_usu_notas_url
  end
end
