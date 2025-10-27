class Aplicacion::MenusController < ApplicationController
  before_action :set_menu, only: %i[ show edit update destroy ]

  # GET /menus or /menus.json
  def index
    @coleccion = Menu.all
  end

  # GET /menus/1 or /menus/1.json
  def show
  end

  # GET /menus/new
  def new
    @objeto = Menu.new
  end

  # GET /menus/1/edit
  def edit
  end

  # POST /menus or /menus.json
  def create
    @objeto = Menu.new(menu_params)

    respond_to do |format|
      if @objeto.save
        format.html { redirect_to @objeto, notice: "Menu was successfully created." }
        format.json { render :show, status: :created, location: @objeto }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /menus/1 or /menus/1.json
  def update
    respond_to do |format|
      if @objeto.update(menu_params)
        format.html { redirect_to @objeto, notice: "Menu was successfully updated." }
        format.json { render :show, status: :ok, location: @objeto }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @objeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /menus/1 or /menus/1.json
  def destroy
    @objeto.destroy!

    respond_to do |format|
      format.html { redirect_to menus_path, status: :see_other, notice: "Menu was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_menu
      @objeto = Menu.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def menu_params
      params.expect(menu: [ :key, :enabled, :items ])
    end
end
