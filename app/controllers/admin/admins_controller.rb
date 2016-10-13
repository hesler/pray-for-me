class Admin::AdminsController < AdminController
  def index
    admins = Admin.all
    render 'admin/admins/index', locals: { admins: admins }
  end
end
