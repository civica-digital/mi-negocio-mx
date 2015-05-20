class DashboardController < ApplicationController
  before_action :verify_admin
  layout 'dashboard'

  def show
    users = User.where(admin: false, city_id: current_user.city_id)
    reminders = Reminders.where(user_id: users)
    total_reminders = reminders.joins(:user).where(user_id: users)

  complaint = {panel: 'panel-primary', awesome_icons_class: 'fa fa-comments fa-5x', 
    value: Complaint.where(city_id: current_user.city_id).count, message: 'Denuncias totales', path: root_path}

  business_creates = {panel: 'panel-primary', awesome_icons_class: 'fa fa-comments fa-5x',
   value: users.count, message: 'Empresarios registrados', path: root_path}

  business_this_week = {panel: 'panel-primary', awesome_icons_class: 'fa fa-comments fa-5x', 
    value: users.where("created_at >= ? ", 1.week.ago.utc).count, message: 'Empresarios nuevos', path: root_path}

  users_with_reminders = {panel: 'panel-primary', awesome_icons_class: 'fa fa-comments fa-5x', 
    value: total_reminders.count, message: 'Recordatorios totales', path: root_path}

  new_reminders = {panel: 'panel-primary', awesome_icons_class: 'fa fa-comments fa-5x', 
    value: total_reminders.uniq.pluck(:user_id).count, message: 'Usuarios con recordatorios', path: root_path}

  documents_until_to = {panel: 'panel-primary', awesome_icons_class: 'fa fa-comments fa-5x', 
    value: total_reminders.where("until_to <= ? ",Date.today() + 30.day).count, message: 'Documentos próximos a vencer', path: '#'}
      
  @kpis = [complaint, business_creates, business_this_week, users_with_reminders,new_reminders,documents_until_to]
  @dependencies = Dependency.where(city_id: current_user.city).count
  @lines = Line.where(city_id: current_user.city).count
  @formation_steps= FormationStep.where(city_id: current_user.city).count
  @requirements = Requirement.where(city_id: current_user.city).count
  @procedures = policy_scope(Procedure).count
  @inspections = policy_scope(Inspection).count
  @inspectors = policy_scope(Inspector).count
  end

end
