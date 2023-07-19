require 'test_helper'

class BlgTemasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @blg_tema = blg_temas(:one)
  end

  test "should get index" do
    get blg_temas_url
    assert_response :success
  end

  test "should get new" do
    get new_blg_tema_url
    assert_response :success
  end

  test "should create blg_tema" do
    assert_difference('BlgTema.count') do
      post blg_temas_url, params: { blg_tema: { blg_tema: @blg_tema.blg_tema } }
    end

    assert_redirected_to blg_tema_url(BlgTema.last)
  end

  test "should show blg_tema" do
    get blg_tema_url(@blg_tema)
    assert_response :success
  end

  test "should get edit" do
    get edit_blg_tema_url(@blg_tema)
    assert_response :success
  end

  test "should update blg_tema" do
    patch blg_tema_url(@blg_tema), params: { blg_tema: { blg_tema: @blg_tema.blg_tema } }
    assert_redirected_to blg_tema_url(@blg_tema)
  end

  test "should destroy blg_tema" do
    assert_difference('BlgTema.count', -1) do
      delete blg_tema_url(@blg_tema)
    end

    assert_redirected_to blg_temas_url
  end
end
