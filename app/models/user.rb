class User < ActiveRecord::Base
  acts_as_authentic do |config|
    config.login_field = :name
    config.require_password_confirmation = false
  end

  attr_accessible :name, :email, :password, :roles

  default_scope :order => 'users.name'
  scope :with_role, lambda { |role| {:conditions => "roles_mask & #{2**ROLES.index(role.to_s)} > 0"} }

  ROLES = %w[admin manager]

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end

  def roles
    ROLES.reject { |r| ((roles_mask || 0) & 2**ROLES.index(r)).zero? }
  end

  def role?(role)
    roles.include? role.to_s
  end

  def role_symbols
    roles.map(&:to_sym)
  end

  def role_names
    roles.map {|role| User.role_name(role) }
  end

  class << self
    def role_name(role)
      I18n.t role.to_sym, :scope => 'activerecord.attributes.user.role_values'
    end

    def collection_of_roles
      ROLES.map {|role| [role, role_name(role)] }
    end
  end

end
