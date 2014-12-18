module Dashboard
  class InspectorsController < ApplicationController
    before_action :set_inspector, only: [:edit, :update, :destroy]
    before_action :authenticate_user!
    layout 'user'

    def new
      @inspector = Inspector.new
      @dependency = Dependency.all
    end

    def edit
    end

    def create
      @inspector = Inspector.new(inspector_params)

      respond_to do |format|
        if @inspector.save
          format.html { redirect_to @inspector, notice: 'Inspector was successfully created.' }
          format.json { render :show, status: :created, location: @inspector }
        else
          format.html { render :new }
          format.json { render json: @inspector.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      respond_to do |format|
        if @inspector.update(inspector_params)
          format.html { redirect_to @inspector, notice: 'Inspector was successfully updated.' }
          format.json { render :show, status: :ok, location: @inspector }
        else
          format.html { render :edit }
          format.json { render json: @inspector.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @inspector.destroy
      respond_to do |format|
        format.html { redirect_to inspectors_url, notice: 'Inspector was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private
    def set_inspector
      @inspector = Inspector.find(params[:id])
    end

    def inspector_params
      params.require(:inspector).permit(:nombre, :vigencia, :materia, :supervisor, :contacto, :foto, :dependency_id)
    end
  end
end
