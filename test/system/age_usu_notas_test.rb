require "application_system_test_case"

class AgeUsuNotasTest < ApplicationSystemTestCase
  setup do
    @age_usu_nota = age_usu_notas(:one)
  end

  test "visiting the index" do
    visit age_usu_notas_url
    assert_selector "h1", text: "Age usu notas"
  end

  test "should create age usu nota" do
    visit age_usu_notas_url
    click_on "New age usu nota"

    fill_in "Age usuario", with: @age_usu_nota.age_usuario_id
    fill_in "Nota", with: @age_usu_nota.nota_id
    click_on "Create Age usu nota"

    assert_text "Age usu nota was successfully created"
    click_on "Back"
  end

  test "should update Age usu nota" do
    visit age_usu_nota_url(@age_usu_nota)
    click_on "Edit this age usu nota", match: :first

    fill_in "Age usuario", with: @age_usu_nota.age_usuario_id
    fill_in "Nota", with: @age_usu_nota.nota_id
    click_on "Update Age usu nota"

    assert_text "Age usu nota was successfully updated"
    click_on "Back"
  end

  test "should destroy Age usu nota" do
    visit age_usu_nota_url(@age_usu_nota)
    click_on "Destroy this age usu nota", match: :first

    assert_text "Age usu nota was successfully destroyed"
  end
end
