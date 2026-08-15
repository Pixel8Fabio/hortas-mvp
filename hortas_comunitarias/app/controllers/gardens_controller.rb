class GardensController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_garden, only: %i[show edit update destroy submit_for_review approve reject]
  before_action :authorize_owner!, only: %i[edit update destroy submit_for_review]
  before_action :require_admin!, only: %i[approve reject]

  def index
     @gardens = Garden.order(:name)
  end

  def show
    return if @garden.approved? || current_user == @garden.user || current_user&.admin?

    redirect_to root_path, alert: "Horta ainda não disponível para consulta."
  end

  def new
    @garden = current_user.gardens.new
  end

  def create
    @garden = current_user.gardens.new(garden_params)

    if @garden.save
      redirect_to @garden, notice: "Horta cadastrada com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @garden.update(garden_params)
      redirect_to @garden, notice: "Cadastro atualizado."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @garden.destroy!
    redirect_to gardens_path, notice: "Cadastro removido."
  end

  def submit_for_review
    @garden.submit_for_review!
    redirect_to @garden, notice: "Cadastro enviado para análise."
  end

  def approve
    @garden.approved!
    redirect_to @garden, notice: "Horta aprovada."
  end

  def reject
    @garden.rejected!
    redirect_to @garden, notice: "Cadastro rejeitado."
  end

  private

  def set_garden
    @garden = Garden.find(params[:id])
  end

  def authorize_owner!
    return if current_user == @garden.user || current_user.admin?

    redirect_to root_path, alert: "Acesso não autorizado."
  end

  def garden_params
    params.require(:garden).permit(
      :name, :description, :garden_type, :street, :number, :district,
      :city, :state, :postal_code, :contact_name, :contact_phone,
      :contact_email, :accepts_volunteers, photos: []
    )
  end
end
