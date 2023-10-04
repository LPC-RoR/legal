require "application_system_test_case"

class TarNotaCreditosTest < ApplicationSystemTestCase
  setup do
    @tar_nota_credito = tar_nota_creditos(:one)
  end

  test "visiting the index" do
    visit tar_nota_creditos_url
    assert_selector "h1", text: "Tar Nota Creditos"
  end

  test "creating a Tar nota credito" do
    visit tar_nota_creditos_url
    click_on "New Tar Nota Credito"

    fill_in "Fecha", with: @tar_nota_credito.fecha
    fill_in "Monto", with: @tar_nota_credito.monto
    check "Monto total" if @tar_nota_credito.monto_total
    fill_in "Numero", with: @tar_nota_credito.numero
    fill_in "Tar factura", with: @tar_nota_credito.tar_factura_id
    click_on "Create Tar nota credito"

    assert_text "Tar nota credito was successfully created"
    click_on "Back"
  end

  test "updating a Tar nota credito" do
    visit tar_nota_creditos_url
    click_on "Edit", match: :first

    fill_in "Fecha", with: @tar_nota_credito.fecha
    fill_in "Monto", with: @tar_nota_credito.monto
    check "Monto total" if @tar_nota_credito.monto_total
    fill_in "Numero", with: @tar_nota_credito.numero
    fill_in "Tar factura", with: @tar_nota_credito.tar_factura_id
    click_on "Update Tar nota credito"

    assert_text "Tar nota credito was successfully updated"
    click_on "Back"
  end

  test "destroying a Tar nota credito" do
    visit tar_nota_creditos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tar nota credito was successfully destroyed"
  end
end
