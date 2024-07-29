require "application_system_test_case"

class HtextosTest < ApplicationSystemTestCase
  setup do
    @htexto = htextos(:one)
  end

  test "visiting the index" do
    visit htextos_url
    assert_selector "h1", text: "Htextos"
  end

  test "should create htexto" do
    visit htextos_url
    click_on "New htexto"

    fill_in "H texto", with: @htexto.h_texto
    fill_in "Imagen", with: @htexto.imagen
    fill_in "Img sz", with: @htexto.img_sz
    fill_in "Lnk", with: @htexto.lnk
    fill_in "Lnk txt", with: @htexto.lnk_txt
    fill_in "Texto", with: @htexto.texto
    click_on "Create Htexto"

    assert_text "Htexto was successfully created"
    click_on "Back"
  end

  test "should update Htexto" do
    visit htexto_url(@htexto)
    click_on "Edit this htexto", match: :first

    fill_in "H texto", with: @htexto.h_texto
    fill_in "Imagen", with: @htexto.imagen
    fill_in "Img sz", with: @htexto.img_sz
    fill_in "Lnk", with: @htexto.lnk
    fill_in "Lnk txt", with: @htexto.lnk_txt
    fill_in "Texto", with: @htexto.texto
    click_on "Update Htexto"

    assert_text "Htexto was successfully updated"
    click_on "Back"
  end

  test "should destroy Htexto" do
    visit htexto_url(@htexto)
    click_on "Destroy this htexto", match: :first

    assert_text "Htexto was successfully destroyed"
  end
end
