require "application_system_test_case"

class TarValoresTest < ApplicationSystemTestCase
  setup do
    @tar_valor = tar_valores(:one)
  end

  test "visiting the index" do
    visit tar_valores_url
    assert_selector "h1", text: "Tar Valores"
  end

  test "creating a Tar valor" do
    visit tar_valores_url
    click_on "New Tar Valor"

    fill_in "Codigo", with: @tar_valor.codigo
    fill_in "Detalle", with: @tar_valor.detalle
    fill_in "Owner class", with: @tar_valor.owner_class
    fill_in "Owner", with: @tar_valor.owner_id
    fill_in "Valor", with: @tar_valor.valor
    fill_in "Valor uf", with: @tar_valor.valor_uf
    click_on "Create Tar valor"

    assert_text "Tar valor was successfully created"
    click_on "Back"
  end

  test "updating a Tar valor" do
    visit tar_valores_url
    click_on "Edit", match: :first

    fill_in "Codigo", with: @tar_valor.codigo
    fill_in "Detalle", with: @tar_valor.detalle
    fill_in "Owner class", with: @tar_valor.owner_class
    fill_in "Owner", with: @tar_valor.owner_id
    fill_in "Valor", with: @tar_valor.valor
    fill_in "Valor uf", with: @tar_valor.valor_uf
    click_on "Update Tar valor"

    assert_text "Tar valor was successfully updated"
    click_on "Back"
  end

  test "destroying a Tar valor" do
    visit tar_valores_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tar valor was successfully destroyed"
  end
end
