require "application_system_test_case"

class ActReferenciasTest < ApplicationSystemTestCase
  setup do
    @act_referencia = act_referencias(:one)
  end

  test "visiting the index" do
    visit act_referencias_url
    assert_selector "h1", text: "Act referencias"
  end

  test "should create act referencia" do
    visit act_referencias_url
    click_on "New act referencia"

    fill_in "Act archivo", with: @act_referencia.act_archivo_id
    fill_in "Ref", with: @act_referencia.ref_id
    fill_in "Ref type", with: @act_referencia.ref_type
    click_on "Create Act referencia"

    assert_text "Act referencia was successfully created"
    click_on "Back"
  end

  test "should update Act referencia" do
    visit act_referencia_url(@act_referencia)
    click_on "Edit this act referencia", match: :first

    fill_in "Act archivo", with: @act_referencia.act_archivo_id
    fill_in "Ref", with: @act_referencia.ref_id
    fill_in "Ref type", with: @act_referencia.ref_type
    click_on "Update Act referencia"

    assert_text "Act referencia was successfully updated"
    click_on "Back"
  end

  test "should destroy Act referencia" do
    visit act_referencia_url(@act_referencia)
    click_on "Destroy this act referencia", match: :first

    assert_text "Act referencia was successfully destroyed"
  end
end
