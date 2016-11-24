class Admin::AdminsController < AdminController
  def index
    admins = Admin.all
    render 'admin/admins/index', locals: { admins: admins }
  end

  def new
    flash.clear
    admin = Admin.new
    render 'admin/admins/new', locals: { admin: admin }
  end

  def create
    admin_create = Admin::Create.new(admin_params)
    admin_create.call
    redirect_to admin_admins_path, flash: { success: 'Admin added' }
  rescue CommonErrors::CommandValidationFailed
    flash[:error] = admin_create.errors
    render 'admin/admins/new', locals: { admin: admin_create.admin }, status: 422
  end

  def destroy
    admin = Admin.find(params[:id])
    Admin::Destroy.new(admin).call
    redirect_to admin_admins_path, flash: { success: 'Admin deleted' }
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_admins_path, flash: { warning: 'Admin does not exist' }
  end

  private

  def admin_params
    params.require(:admin).permit(:email, :password, :password_confirmation, :first_name, :last_name).to_h
  end
end
