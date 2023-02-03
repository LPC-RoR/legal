require "application_system_test_case"

class TarHorasTest < ApplicationSystemTestCase
  setup do
    @tar_hora = tar_horas(:one)
  end

  test "visiting the index" do
    visit tar_horas_url
    assert_selector "h1", text: "Tar Horas"
  end

  test "creating a Tar hora" do
    visit tar_horas_url
    click_on "New Tar Hora"

    fill_in "Moneda", with: @tar_hora.moneda
    fill_in "Owner class", with: @tar_hora.owner_class
    fill_in "Owner", with: @tar_hora.owner_id
    fill_in "Tar hora", with: @tar_hora.tar_hora
    fill_in "Valor", with: @tar_hora.valor
    click_on "Create Tar hora"

    assert_text "Tar hora was successfully created"
    click_on "Back"
  end

  test "updating a Tar hora" do
    visit tar_horas_url
    click_on "Edit", match: :first

    fill_in "Moneda", with: @tar_hora.moneda
    fill_in "Owner class", with: @tar_hora.owner_class
    fill_in "Owner", with: @tar_hora.owner_id
    fill_in "Tar hora", with: @tar_hora.tar_hora
    fill_in "Valor", with: @tar_hora.valor
    click_on "Update Tar hora"

    assert_text "Tar hora was successfully updated"
    click_on "Back"
  end

  test "destroying a Tar hora" do
    visit tar_horas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tar hora was successfully destroyed"
  end
end
