require "application_system_test_case"

class ActArchivosTest < ApplicationSystemTestCase
  setup do
    @act_archivo = act_archivos(:one)
  end

  test "visiting the index" do
    visit act_archivos_url
    assert_selector "h1", text: "Act archivos"
  end

  test "should create act archivo" do
    visit act_archivos_url
    click_on "New act archivo"

    fill_in "Act archivo", with: @act_archivo.act_archivo
    fill_in "Nombre", with: @act_archivo.nombre
    click_on "Create Act archivo"

    assert_text "Act archivo was successfully created"
    click_on "Back"
  end

  test "should update Act archivo" do
    visit act_archivo_url(@act_archivo)
    click_on "Edit this act archivo", match: :first

    fill_in "Act archivo", with: @act_archivo.act_archivo
    fill_in "Nombre", with: @act_archivo.nombre
    click_on "Update Act archivo"

    assert_text "Act archivo was successfully updated"
    click_on "Back"
  end

  test "should destroy Act archivo" do
    visit act_archivo_url(@act_archivo)
    click_on "Destroy this act archivo", match: :first

    assert_text "Act archivo was successfully destroyed"
  end
end
