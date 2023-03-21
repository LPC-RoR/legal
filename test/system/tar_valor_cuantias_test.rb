require "application_system_test_case"

class TarValorCuantiasTest < ApplicationSystemTestCase
  setup do
    @tar_valor_cuantia = tar_valor_cuantias(:one)
  end

  test "visiting the index" do
    visit tar_valor_cuantias_url
    assert_selector "h1", text: "Tar Valor Cuantias"
  end

  test "creating a Tar valor cuantia" do
    visit tar_valor_cuantias_url
    click_on "New Tar Valor Cuantia"

    fill_in "Otro detalle", with: @tar_valor_cuantia.otro_detalle
    fill_in "Owner class", with: @tar_valor_cuantia.owner_class
    fill_in "Owner", with: @tar_valor_cuantia.owner_id
    fill_in "Tar detalle cuantia", with: @tar_valor_cuantia.tar_detalle_cuantia_id
    fill_in "Valor", with: @tar_valor_cuantia.valor
    fill_in "Valor uf", with: @tar_valor_cuantia.valor_uf
    click_on "Create Tar valor cuantia"

    assert_text "Tar valor cuantia was successfully created"
    click_on "Back"
  end

  test "updating a Tar valor cuantia" do
    visit tar_valor_cuantias_url
    click_on "Edit", match: :first

    fill_in "Otro detalle", with: @tar_valor_cuantia.otro_detalle
    fill_in "Owner class", with: @tar_valor_cuantia.owner_class
    fill_in "Owner", with: @tar_valor_cuantia.owner_id
    fill_in "Tar detalle cuantia", with: @tar_valor_cuantia.tar_detalle_cuantia_id
    fill_in "Valor", with: @tar_valor_cuantia.valor
    fill_in "Valor uf", with: @tar_valor_cuantia.valor_uf
    click_on "Update Tar valor cuantia"

    assert_text "Tar valor cuantia was successfully updated"
    click_on "Back"
  end

  test "destroying a Tar valor cuantia" do
    visit tar_valor_cuantias_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tar valor cuantia was successfully destroyed"
  end
end
