class Service::Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController

  def sign_up_params
    params.permit(*params_for_resource(:sign_up), :name)
  end

  protected

  def build_resource
    super
    @resource.competition = Competition.find_by(rid: params[:rid])
  end
end
