require "application_system_test_case"

class DtInfraccionesTest < ApplicationSystemTestCase
  setup do
    @dt_infraccion = dt_infracciones(:one)
  end

  test "visiting the index" do
    visit dt_infracciones_url
    assert_selector "h1", text: "Dt Infracciones"
  end

  test "creating a Dt infraccion" do
    visit dt_infracciones_url
    click_on "New Dt Infraccion"

    fill_in "Codigo", with: @dt_infraccion.codigo
    fill_in "Criterios", with: @dt_infraccion.criterios
    fill_in "Dt infraccion", with: @dt_infraccion.dt_infraccion
    fill_in "Dt materia", with: @dt_infraccion.dt_materia_id
    fill_in "Normas", with: @dt_infraccion.normas
    fill_in "Tipificacion", with: @dt_infraccion.tipificacion
    click_on "Create Dt infraccion"

    assert_text "Dt infraccion was successfully created"
    click_on "Back"
  end

  test "updating a Dt infraccion" do
    visit dt_infracciones_url
    click_on "Edit", match: :first

    fill_in "Codigo", with: @dt_infraccion.codigo
    fill_in "Criterios", with: @dt_infraccion.criterios
    fill_in "Dt infraccion", with: @dt_infraccion.dt_infraccion
    fill_in "Dt materia", with: @dt_infraccion.dt_materia_id
    fill_in "Normas", with: @dt_infraccion.normas
    fill_in "Tipificacion", with: @dt_infraccion.tipificacion
    click_on "Update Dt infraccion"

    assert_text "Dt infraccion was successfully updated"
    click_on "Back"
  end

  test "destroying a Dt infraccion" do
    visit dt_infracciones_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Dt infraccion was successfully destroyed"
  end
end
