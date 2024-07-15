require "application_system_test_case"

class HmPaginasTest < ApplicationSystemTestCase
  setup do
    @hm_pagina = hm_paginas(:one)
  end

  test "visiting the index" do
    visit hm_paginas_url
    assert_selector "h1", text: "Hm paginas"
  end

  test "should create hm pagina" do
    visit hm_paginas_url
    click_on "New hm pagina"

    fill_in "Codigo", with: @hm_pagina.codigo
    fill_in "Hm pagina", with: @hm_pagina.hm_pagina
    fill_in "Ownr clss", with: @hm_pagina.ownr_clss
    fill_in "Ownr", with: @hm_pagina.ownr_id
    fill_in "Tooltip", with: @hm_pagina.tooltip
    click_on "Create Hm pagina"

    assert_text "Hm pagina was successfully created"
    click_on "Back"
  end

  test "should update Hm pagina" do
    visit hm_pagina_url(@hm_pagina)
    click_on "Edit this hm pagina", match: :first

    fill_in "Codigo", with: @hm_pagina.codigo
    fill_in "Hm pagina", with: @hm_pagina.hm_pagina
    fill_in "Ownr clss", with: @hm_pagina.ownr_clss
    fill_in "Ownr", with: @hm_pagina.ownr_id
    fill_in "Tooltip", with: @hm_pagina.tooltip
    click_on "Update Hm pagina"

    assert_text "Hm pagina was successfully updated"
    click_on "Back"
  end

  test "should destroy Hm pagina" do
    visit hm_pagina_url(@hm_pagina)
    click_on "Destroy this hm pagina", match: :first

    assert_text "Hm pagina was successfully destroyed"
  end
end
