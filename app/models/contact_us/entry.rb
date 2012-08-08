class ContactUs::Entry < ActiveRecord::Base
  self.table_name = "contact_us_entries"

  attr_accessible :content, :email, :name, :phone

  validates :name, :content, :email, presence: true

  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates :email, format: {
    with: EMAIL_REGEX,
    message: I18n.t("activerecord.errors.messages.valid_email") }

  default_scope order: ['contact_us_entries.created_at DESC']
end
