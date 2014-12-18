class VacationsController < ApplicationController
  include Shared::RespondsController
  include Calendar

  expose_decorated(:user)
  expose(:vacation)
  expose(:all_vacations) { Vacation.all }
  expose(:vacations) { user.vacations }

  before_filter :authenticate_admin!, only: [:update], unless: -> { current_user? }

  def index
    @users = User.all.decorate
  end

  def new
    user.vacations.build
  end

  def create
    vacation = user.vacations.build(vacation_params)
    if vacation.save
      export_vacation(vacation)
      respond_on_success vacations_path
    else
      respond_on_failure vacation.errors
    end
  end

  def update
    vacation = Vacation.find(params[:id])
    if vacation.update(vacation_params)
      update_vacation(vacation) if vacation.eventid.present?
      respond_on_success vacations_path
    else
      respond_on_failure vacation.errors
    end
  end

  def destroy
    vacation = Vacation.find(params[:id])
    if vacation.destroy
      delete_vacation(vacation) if vacation.eventid.present?
      respond_on_success vacations_path
    else
      respond_on_failure vacation.errors
    end
  end

  def import
    import_vacation(current_user)
    redirect_to '/vacations'
  end

  private

  def vacation_params
    params.require(:vacation).permit(:starts_at, :ends_at, :user_id, :id)
  end
end
