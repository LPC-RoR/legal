require "application_system_test_case"

class HmParrafosTest < ApplicationSystemTestCase
  setup do
    @hm_parrafo = hm_parrafos(:one)
  end

  test "visiting the index" do
    visit hm_parrafos_url
    assert_selector "h1", text: "Hm parrafos"
  end

  test "should create hm parrafo" do
    visit hm_parrafos_url
    click_on "New hm parrafo"

    fill_in "Hm pagina", with: @hm_parrafo.hm_pagina_id
    fill_in "Hm parrafo", with: @hm_parrafo.hm_parrafo
    fill_in "Imagen", with: @hm_parrafo.imagen
    fill_in "Img lyt", with: @hm_parrafo.img_lyt
    fill_in "Orden", with: @hm_parrafo.orden
    fill_in "Tipo", with: @hm_parrafo.tipo
    click_on "Create Hm parrafo"

    assert_text "Hm parrafo was successfully created"
    click_on "Back"
  end

  test "should update Hm parrafo" do
    visit hm_parrafo_url(@hm_parrafo)
    click_on "Edit this hm parrafo", match: :first

    fill_in "Hm pagina", with: @hm_parrafo.hm_pagina_id
    fill_in "Hm parrafo", with: @hm_parrafo.hm_parrafo
    fill_in "Imagen", with: @hm_parrafo.imagen
    fill_in "Img lyt", with: @hm_parrafo.img_lyt
    fill_in "Orden", with: @hm_parrafo.orden
    fill_in "Tipo", with: @hm_parrafo.tipo
    click_on "Update Hm parrafo"

    assert_text "Hm parrafo was successfully updated"
    click_on "Back"
  end

  test "should destroy Hm parrafo" do
    visit hm_parrafo_url(@hm_parrafo)
    click_on "Destroy this hm parrafo", match: :first

    assert_text "Hm parrafo was successfully destroyed"
  end
end
