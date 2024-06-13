class Modelos::MRegFactsController < ApplicationController
  before_action :set_m_reg_fact, only: %i[ show edit update destroy ]

  # GET /m_reg_facts or /m_reg_facts.json
  def index
    @m_reg_facts = MRegFact.all
  end

  # GET /m_reg_facts/1 or /m_reg_facts/1.json
  def show
  end

  # GET /m_reg_facts/new
  def new
    @m_reg_fact = MRegFact.new
  end

  # GET /m_reg_facts/1/edit
  def edit
  end

  # POST /m_reg_facts or /m_reg_facts.json
  def create
    @m_reg_fact = MRegFact.new(m_reg_fact_params)

    respond_to do |format|
      if @m_reg_fact.save
        format.html { redirect_to @m_reg_fact, notice: "M reg fact was successfully created." }
        format.json { render :show, status: :created, location: @m_reg_fact }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @m_reg_fact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /m_reg_facts/1 or /m_reg_facts/1.json
  def update
    respond_to do |format|
      if @m_reg_fact.update(m_reg_fact_params)
        format.html { redirect_to @m_reg_fact, notice: "M reg fact was successfully updated." }
        format.json { render :show, status: :ok, location: @m_reg_fact }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @m_reg_fact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /m_reg_facts/1 or /m_reg_facts/1.json
  def destroy
    @m_reg_fact.destroy
    respond_to do |format|
      format.html { redirect_to m_reg_facts_url, notice: "M reg fact was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_m_reg_fact
      @m_reg_fact = MRegFact.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def m_reg_fact_params
      params.require(:m_reg_fact).permit(:m_registro_id, :tar_factura, :monto)
    end
end
