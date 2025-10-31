require "application_system_test_case"

class ActTextosTest < ApplicationSystemTestCase
  setup do
    @act_texto = act_textos(:one)
  end

  test "visiting the index" do
    visit act_textos_url
    assert_selector "h1", text: "Act textos"
  end

  test "should create act texto" do
    visit act_textos_url
    click_on "New act texto"

    fill_in "Tipo documento", with: @act_texto.tipo_documento
    click_on "Create Act texto"

    assert_text "Act texto was successfully created"
    click_on "Back"
  end

  test "should update Act texto" do
    visit act_texto_url(@act_texto)
    click_on "Edit this act texto", match: :first

    fill_in "Tipo documento", with: @act_texto.tipo_documento
    click_on "Update Act texto"

    assert_text "Act texto was successfully updated"
    click_on "Back"
  end

  test "should destroy Act texto" do
    visit act_texto_url(@act_texto)
    click_on "Destroy this act texto", match: :first

    assert_text "Act texto was successfully destroyed"
  end
end
