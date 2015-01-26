module Dashboard
  class DependenciesController < ApplicationController
    before_action :set_dependency, only: [:edit, :update, :destroy]
    before_action :authenticate_user!
    layout 'dashboard'

    def index 
      @dependencies = policy_scope(Dependency).where(municipio_id: current_user.municipio)
    end

    def new
      @dependency = Dependency.new
    end

    def edit
    end

    def create
      @dependency = Dependency.new(dependency_params)
      @dependency.municipio = current_user.municipio
      authorize @dependency

      respond_to do |format|
        if @dependency.save
          format.html { redirect_to edit_dashboard_dependency_url(@dependency), notice: 'La dependencia fue creada satisfactoriamente.' }
          format.json { render :show, status: :created, location: @dependency }
        else
          format.html { render :new }
          format.json { render json: @dependency.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      authorize @dependency

      respond_to do |format|
        if @dependency.update(dependency_params)
          format.html { redirect_to edit_dashboard_dependency_url(@dependency), notice: 'La dependencia fue actualizada satisfactoriamente.' }
          format.json { render :show, status: :ok, location: @dependency }
        else
          format.html { render :edit }
          format.json { render json: @dependency.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      authorize @dependency

      @dependency.destroy
      respond_to do |format|
        format.html { redirect_to dashboard_dependencies_path notice: 'La dependencia fue borrada satisfactoriamente.' }
        format.json { head :no_content }
      end
    end

    private
    def set_dependency
      @dependency = Dependency.find(params[:id])
    end

    def dependency_params
      params.require(:dependency).permit(:nombre, :municipio_id)
    end
  end
end