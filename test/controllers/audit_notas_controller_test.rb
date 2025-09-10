require "test_helper"

class AuditNotasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @audit_nota = audit_notas(:one)
  end

  test "should get index" do
    get audit_notas_url
    assert_response :success
  end

  test "should get new" do
    get new_audit_nota_url
    assert_response :success
  end

  test "should create audit_nota" do
    assert_difference("AuditNota.count") do
      post audit_notas_url, params: { audit_nota: { app_pefil_id: @audit_nota.app_pefil_id, nota: @audit_nota.nota, ownr_id: @audit_nota.ownr_id, ownr_type: @audit_nota.ownr_type, prioridad: @audit_nota.prioridad, recomendacion: @audit_nota.recomendacion } }
    end

    assert_redirected_to audit_nota_url(AuditNota.last)
  end

  test "should show audit_nota" do
    get audit_nota_url(@audit_nota)
    assert_response :success
  end

  test "should get edit" do
    get edit_audit_nota_url(@audit_nota)
    assert_response :success
  end

  test "should update audit_nota" do
    patch audit_nota_url(@audit_nota), params: { audit_nota: { app_pefil_id: @audit_nota.app_pefil_id, nota: @audit_nota.nota, ownr_id: @audit_nota.ownr_id, ownr_type: @audit_nota.ownr_type, prioridad: @audit_nota.prioridad, recomendacion: @audit_nota.recomendacion } }
    assert_redirected_to audit_nota_url(@audit_nota)
  end

  test "should destroy audit_nota" do
    assert_difference("AuditNota.count", -1) do
      delete audit_nota_url(@audit_nota)
    end

    assert_redirected_to audit_notas_url
  end
end
