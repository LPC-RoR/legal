require 'test_helper'

class TemasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tema = temas(:one)
  end

  test "should get index" do
    get temas_url
    assert_response :success
  end

  test "should get new" do
    get new_tema_url
    assert_response :success
  end

  test "should create tema" do
    assert_difference('Tema.count') do
      post temas_url, params: { tema: { causa_id: @tema.causa_id, descripcion: @tema.descripcion, orden: @tema.orden, tema: @tema.tema } }
    end

    assert_redirected_to tema_url(Tema.last)
  end

  test "should show tema" do
    get tema_url(@tema)
    assert_response :success
  end

  test "should get edit" do
    get edit_tema_url(@tema)
    assert_response :success
  end

  test "should update tema" do
    patch tema_url(@tema), params: { tema: { causa_id: @tema.causa_id, descripcion: @tema.descripcion, orden: @tema.orden, tema: @tema.tema } }
    assert_redirected_to tema_url(@tema)
  end

  test "should destroy tema" do
    assert_difference('Tema.count', -1) do
      delete tema_url(@tema)
    end

    assert_redirected_to temas_url
  end
end
