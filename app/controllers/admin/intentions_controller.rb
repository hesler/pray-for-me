class Admin::IntentionsController < AdminController
  def index
    intentions = Intention.all
    render 'admin/intentions/index', locals: { intentions: intentions }
  end

  def new
    flash.clear
    intention = Intention.new
    render 'admin/intentions/new', locals: { intention: intention }
  end

  def create
    intention_create = Intention::Create.new(intention_create_params)
    intention_create.call
    redirect_to admin_intentions_path, flash: { success: 'Intention added' }
  rescue CommonErrors::CommandValidationFailed
    flash[:error] = intention_create.errors
    render 'admin/intentions/new', locals: { intention: intention_create.intention }
  end

  private

  def intention_create_params
    params.require(:intention).permit(:content, :country, :region, :city, :lat, :lng).to_h
  end
end
