class ContactUs::EntriesController < ApplicationController
  def new
    @contact_us = ContactUs::Entry.new
  end

  def create
    @contact_us = ContactUs::Entry.new params[:contact_us_entry]
    if @contact_us.save
      redirect_to new_contact_u_path, notice: I18n.t(:contacts_was_sent)
    else
      render :new
    end
  end
end
