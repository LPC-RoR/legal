require "application_system_test_case"

class TxtEditablesTest < ApplicationSystemTestCase
  setup do
    @txt_editable = txt_editables(:one)
  end

  test "visiting the index" do
    visit txt_editables_url
    assert_selector "h1", text: "Txt editables"
  end

  test "should create txt editable" do
    visit txt_editables_url
    click_on "New txt editable"

    fill_in "Codigo", with: @txt_editable.codigo
    fill_in "Ownr", with: @txt_editable.ownr_id
    fill_in "Ownr type", with: @txt_editable.ownr_type
    fill_in "Titulo", with: @txt_editable.titulo
    click_on "Create Txt editable"

    assert_text "Txt editable was successfully created"
    click_on "Back"
  end

  test "should update Txt editable" do
    visit txt_editable_url(@txt_editable)
    click_on "Edit this txt editable", match: :first

    fill_in "Codigo", with: @txt_editable.codigo
    fill_in "Ownr", with: @txt_editable.ownr_id
    fill_in "Ownr type", with: @txt_editable.ownr_type
    fill_in "Titulo", with: @txt_editable.titulo
    click_on "Update Txt editable"

    assert_text "Txt editable was successfully updated"
    click_on "Back"
  end

  test "should destroy Txt editable" do
    visit txt_editable_url(@txt_editable)
    click_on "Destroy this txt editable", match: :first

    assert_text "Txt editable was successfully destroyed"
  end
end
