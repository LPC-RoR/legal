require "application_system_test_case"

class PautasTest < ApplicationSystemTestCase
  setup do
    @pauta = pautas(:one)
  end

  test "visiting the index" do
    visit pautas_url
    assert_selector "h1", text: "Pautas"
  end

  test "should create pauta" do
    visit pautas_url
    click_on "New pauta"

    fill_in "Orden", with: @pauta.orden
    fill_in "Pauta", with: @pauta.pauta
    fill_in "Referencia", with: @pauta.referencia
    click_on "Create Pauta"

    assert_text "Pauta was successfully created"
    click_on "Back"
  end

  test "should update Pauta" do
    visit pauta_url(@pauta)
    click_on "Edit this pauta", match: :first

    fill_in "Orden", with: @pauta.orden
    fill_in "Pauta", with: @pauta.pauta
    fill_in "Referencia", with: @pauta.referencia
    click_on "Update Pauta"

    assert_text "Pauta was successfully updated"
    click_on "Back"
  end

  test "should destroy Pauta" do
    visit pauta_url(@pauta)
    click_on "Destroy this pauta", match: :first

    assert_text "Pauta was successfully destroyed"
  end
end
