require "application_system_test_case"

class TarUfSistemasTest < ApplicationSystemTestCase
  setup do
    @tar_uf_sistema = tar_uf_sistemas(:one)
  end

  test "visiting the index" do
    visit tar_uf_sistemas_url
    assert_selector "h1", text: "Tar Uf Sistemas"
  end

  test "creating a Tar uf sistema" do
    visit tar_uf_sistemas_url
    click_on "New Tar Uf Sistema"

    fill_in "Fecha", with: @tar_uf_sistema.fecha
    fill_in "Valor", with: @tar_uf_sistema.valor
    click_on "Create Tar uf sistema"

    assert_text "Tar uf sistema was successfully created"
    click_on "Back"
  end

  test "updating a Tar uf sistema" do
    visit tar_uf_sistemas_url
    click_on "Edit", match: :first

    fill_in "Fecha", with: @tar_uf_sistema.fecha
    fill_in "Valor", with: @tar_uf_sistema.valor
    click_on "Update Tar uf sistema"

    assert_text "Tar uf sistema was successfully updated"
    click_on "Back"
  end

  test "destroying a Tar uf sistema" do
    visit tar_uf_sistemas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tar uf sistema was successfully destroyed"
  end
end
