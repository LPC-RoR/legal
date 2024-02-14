require "application_system_test_case"

class AgePendientesTest < ApplicationSystemTestCase
  setup do
    @age_pendiente = age_pendientes(:one)
  end

  test "visiting the index" do
    visit age_pendientes_url
    assert_selector "h1", text: "Age Pendientes"
  end

  test "creating a Age pendiente" do
    visit age_pendientes_url
    click_on "New Age Pendiente"

    fill_in "Age pendiente", with: @age_pendiente.age_pendiente
    fill_in "Age usuario", with: @age_pendiente.age_usuario_id
    fill_in "Estado", with: @age_pendiente.estado
    fill_in "Prioridad", with: @age_pendiente.prioridad
    click_on "Create Age pendiente"

    assert_text "Age pendiente was successfully created"
    click_on "Back"
  end

  test "updating a Age pendiente" do
    visit age_pendientes_url
    click_on "Edit", match: :first

    fill_in "Age pendiente", with: @age_pendiente.age_pendiente
    fill_in "Age usuario", with: @age_pendiente.age_usuario_id
    fill_in "Estado", with: @age_pendiente.estado
    fill_in "Prioridad", with: @age_pendiente.prioridad
    click_on "Update Age pendiente"

    assert_text "Age pendiente was successfully updated"
    click_on "Back"
  end

  test "destroying a Age pendiente" do
    visit age_pendientes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Age pendiente was successfully destroyed"
  end
end
