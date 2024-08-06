require "application_system_test_case"

class ProNominasTest < ApplicationSystemTestCase
  setup do
    @pro_nomina = pro_nominas(:one)
  end

  test "visiting the index" do
    visit pro_nominas_url
    assert_selector "h1", text: "Pro nominas"
  end

  test "should create pro nomina" do
    visit pro_nominas_url
    click_on "New pro nomina"

    fill_in "App nomina", with: @pro_nomina.app_nomina_id
    fill_in "Producto", with: @pro_nomina.producto_id
    click_on "Create Pro nomina"

    assert_text "Pro nomina was successfully created"
    click_on "Back"
  end

  test "should update Pro nomina" do
    visit pro_nomina_url(@pro_nomina)
    click_on "Edit this pro nomina", match: :first

    fill_in "App nomina", with: @pro_nomina.app_nomina_id
    fill_in "Producto", with: @pro_nomina.producto_id
    click_on "Update Pro nomina"

    assert_text "Pro nomina was successfully updated"
    click_on "Back"
  end

  test "should destroy Pro nomina" do
    visit pro_nomina_url(@pro_nomina)
    click_on "Destroy this pro nomina", match: :first

    assert_text "Pro nomina was successfully destroyed"
  end
end
