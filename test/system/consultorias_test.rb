require "application_system_test_case"

class ConsultoriasTest < ApplicationSystemTestCase
  setup do
    @consultoria = consultorias(:one)
  end

  test "visiting the index" do
    visit consultorias_url
    assert_selector "h1", text: "Consultorias"
  end

  test "creating a Consultoria" do
    visit consultorias_url
    click_on "New Consultoria"

    fill_in "Cliente", with: @consultoria.cliente_id
    fill_in "Consultoria", with: @consultoria.consultoria
    fill_in "Estado", with: @consultoria.estado
    fill_in "Tar tarea", with: @consultoria.tar_tarea_id
    click_on "Create Consultoria"

    assert_text "Consultoria was successfully created"
    click_on "Back"
  end

  test "updating a Consultoria" do
    visit consultorias_url
    click_on "Edit", match: :first

    fill_in "Cliente", with: @consultoria.cliente_id
    fill_in "Consultoria", with: @consultoria.consultoria
    fill_in "Estado", with: @consultoria.estado
    fill_in "Tar tarea", with: @consultoria.tar_tarea_id
    click_on "Update Consultoria"

    assert_text "Consultoria was successfully updated"
    click_on "Back"
  end

  test "destroying a Consultoria" do
    visit consultorias_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Consultoria was successfully destroyed"
  end
end
