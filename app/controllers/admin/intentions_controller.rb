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
    intention_create = Intention::Create.new(intention_params)
    intention_create.call
    redirect_to admin_intentions_path, flash: { success: 'Intention added' }
  rescue CommonErrors::CommandValidationFailed
    flash[:error] = intention_create.errors
    render 'admin/intentions/new', locals: { intention: intention_create.intention }, status: 422
  end

  def edit
    flash.clear
    intention = Intention.find(params[:id])
    render 'admin/intentions/edit', locals: { intention: intention }
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_intentions_path, flash: { warning: 'Intention does not exist' }
  end

  def update
    intention = Intention.find(params[:id])
    intention_update = Intention::Update.new(intention, intention_params)
    intention_update.call
    redirect_to admin_intentions_path, flash: { success: 'Intention updated' }
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_intentions_path, flash: { warning: 'Intention does not exist' }
  rescue CommonErrors::CommandValidationFailed
    flash[:error] = intention_update.errors
    render 'admin/intentions/edit', locals: { intention: intention_update.intention }, status: 422
  end

  private

  def intention_params
    params.require(:intention).permit(:content, :country, :region, :city, :lat, :lng).to_h
  end
end
