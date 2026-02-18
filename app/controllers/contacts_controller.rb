class ContactsController < ApplicationController
  before_action :authenticate_user!

  def new
    @q = params[:q].to_s.strip

    @users = User.where.not(id: current_user.id)
                .where.not(id: current_user.contacts.select(:id))

    if @q.present?
      term = "%#{@q.downcase}%"
      @users = @users.where("LOWER(username) LIKE ? OR LOWER(email) LIKE ?", term, term)
    end

    @users = @users.order(:username)
  end

  def create
    contact_user = User.find(params[:contact_user_id])
    current_user.contacts.find_or_create_by!(contact_user: contact_user)
    redirect_to new_contact_path, status: :see_other
  end

  def destroy
    contact = current_user.contacts.find(params[:id])
    removed_user = contact.contact_user
    contact.destroy
    redirect_back fallback_location: user_path(removed_user)
  end
end