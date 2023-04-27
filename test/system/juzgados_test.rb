require "application_system_test_case"

class JuzgadosTest < ApplicationSystemTestCase
  setup do
    @juzgado = juzgados(:one)
  end

  test "visiting the index" do
    visit juzgados_url
    assert_selector "h1", text: "Juzgados"
  end

  test "creating a Juzgado" do
    visit juzgados_url
    click_on "New Juzgado"

    fill_in "Juzgado", with: @juzgado.juzgado
    click_on "Create Juzgado"

    assert_text "Juzgado was successfully created"
    click_on "Back"
  end

  test "updating a Juzgado" do
    visit juzgados_url
    click_on "Edit", match: :first

    fill_in "Juzgado", with: @juzgado.juzgado
    click_on "Update Juzgado"

    assert_text "Juzgado was successfully updated"
    click_on "Back"
  end

  test "destroying a Juzgado" do
    visit juzgados_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Juzgado was successfully destroyed"
  end
end
