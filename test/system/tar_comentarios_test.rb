require "application_system_test_case"

class TarComentariosTest < ApplicationSystemTestCase
  setup do
    @tar_comentario = tar_comentarios(:one)
  end

  test "visiting the index" do
    visit tar_comentarios_url
    assert_selector "h1", text: "Tar Comentarios"
  end

  test "creating a Tar comentario" do
    visit tar_comentarios_url
    click_on "New Tar Comentario"

    fill_in "Comentario", with: @tar_comentario.comentario
    fill_in "Formula", with: @tar_comentario.formula
    fill_in "Opcional", with: @tar_comentario.opcional
    fill_in "Orden", with: @tar_comentario.orden
    fill_in "Tar pago", with: @tar_comentario.tar_pago_id
    fill_in "Tipo", with: @tar_comentario.tipo
    click_on "Create Tar comentario"

    assert_text "Tar comentario was successfully created"
    click_on "Back"
  end

  test "updating a Tar comentario" do
    visit tar_comentarios_url
    click_on "Edit", match: :first

    fill_in "Comentario", with: @tar_comentario.comentario
    fill_in "Formula", with: @tar_comentario.formula
    fill_in "Opcional", with: @tar_comentario.opcional
    fill_in "Orden", with: @tar_comentario.orden
    fill_in "Tar pago", with: @tar_comentario.tar_pago_id
    fill_in "Tipo", with: @tar_comentario.tipo
    click_on "Update Tar comentario"

    assert_text "Tar comentario was successfully updated"
    click_on "Back"
  end

  test "destroying a Tar comentario" do
    visit tar_comentarios_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tar comentario was successfully destroyed"
  end
end
