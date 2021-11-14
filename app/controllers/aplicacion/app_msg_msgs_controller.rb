class AppMsgMsgsController < ApplicationController
  before_action :set_app_msg_msg, only: %i[ show edit update destroy ]

  # GET /app_msg_msgs or /app_msg_msgs.json
  def index
    @app_msg_msgs = AppMsgMsg.all
  end

  # GET /app_msg_msgs/1 or /app_msg_msgs/1.json
  def show
  end

  # GET /app_msg_msgs/new
  def new
    @app_msg_msg = AppMsgMsg.new
  end

  # GET /app_msg_msgs/1/edit
  def edit
  end

  # POST /app_msg_msgs or /app_msg_msgs.json
  def create
    @app_msg_msg = AppMsgMsg.new(app_msg_msg_params)

    respond_to do |format|
      if @app_msg_msg.save
        format.html { redirect_to @app_msg_msg, notice: "App msg msg was successfully created." }
        format.json { render :show, status: :created, location: @app_msg_msg }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @app_msg_msg.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /app_msg_msgs/1 or /app_msg_msgs/1.json
  def update
    respond_to do |format|
      if @app_msg_msg.update(app_msg_msg_params)
        format.html { redirect_to @app_msg_msg, notice: "App msg msg was successfully updated." }
        format.json { render :show, status: :ok, location: @app_msg_msg }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @app_msg_msg.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_msg_msgs/1 or /app_msg_msgs/1.json
  def destroy
    @app_msg_msg.destroy
    respond_to do |format|
      format.html { redirect_to app_msg_msgs_url, notice: "App msg msg was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_msg_msg
      @app_msg_msg = AppMsgMsg.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def app_msg_msg_params
      params.require(:app_msg_msg).permit(:parent_id, :child_id)
    end
end
