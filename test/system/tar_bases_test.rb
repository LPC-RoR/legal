require "application_system_test_case"

class TarBasesTest < ApplicationSystemTestCase
  setup do
    @tar_bas = tar_bases(:one)
  end

  test "visiting the index" do
    visit tar_bases_url
    assert_selector "h1", text: "Tar Bases"
  end

  test "creating a Tar base" do
    visit tar_bases_url
    click_on "New Tar Base"

    fill_in "Monto", with: @tar_bas.monto
    fill_in "Monto uf", with: @tar_bas.monto_uf
    fill_in "Owner class", with: @tar_bas.owner_class
    fill_in "Owner", with: @tar_bas.owner_id
    fill_in "Perfil", with: @tar_bas.perfil_id
    click_on "Create Tar base"

    assert_text "Tar base was successfully created"
    click_on "Back"
  end

  test "updating a Tar base" do
    visit tar_bases_url
    click_on "Edit", match: :first

    fill_in "Monto", with: @tar_bas.monto
    fill_in "Monto uf", with: @tar_bas.monto_uf
    fill_in "Owner class", with: @tar_bas.owner_class
    fill_in "Owner", with: @tar_bas.owner_id
    fill_in "Perfil", with: @tar_bas.perfil_id
    click_on "Update Tar base"

    assert_text "Tar base was successfully updated"
    click_on "Back"
  end

  test "destroying a Tar base" do
    visit tar_bases_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tar base was successfully destroyed"
  end
end
