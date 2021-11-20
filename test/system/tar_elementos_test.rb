require "application_system_test_case"

class TarElementosTest < ApplicationSystemTestCase
  setup do
    @tar_elemento = tar_elementos(:one)
  end

  test "visiting the index" do
    visit tar_elementos_url
    assert_selector "h1", text: "Tar Elementos"
  end

  test "creating a Tar elemento" do
    visit tar_elementos_url
    click_on "New Tar Elemento"

    fill_in "Codigo", with: @tar_elemento.codigo
    fill_in "Elemento", with: @tar_elemento.elemento
    fill_in "Orden", with: @tar_elemento.orden
    click_on "Create Tar elemento"

    assert_text "Tar elemento was successfully created"
    click_on "Back"
  end

  test "updating a Tar elemento" do
    visit tar_elementos_url
    click_on "Edit", match: :first

    fill_in "Codigo", with: @tar_elemento.codigo
    fill_in "Elemento", with: @tar_elemento.elemento
    fill_in "Orden", with: @tar_elemento.orden
    click_on "Update Tar elemento"

    assert_text "Tar elemento was successfully updated"
    click_on "Back"
  end

  test "destroying a Tar elemento" do
    visit tar_elementos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tar elemento was successfully destroyed"
  end
end
