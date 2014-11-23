class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  has_and_belongs_to_many :roles, :dependent => :restrict_with_error
  has_and_belongs_to_many :groups, :dependent => :restrict_with_error
  has_many :items, inverse_of: :user, :dependent => :restrict_with_error
  has_many :comments, :dependent => :restrict_with_error
  belongs_to :department
  has_paper_trail :ignore => [:updated_at]
  has_many :checkouts, :dependent => :restrict_with_error
  has_many :cloths, :dependent => :restrict_with_error
validates :department, presence: true
def to_label_sms
  "#{firstname.capitalize} #{lastname.capitalize}"
end
def has_role?(role_sym)
  roles.any? { |r| r.name.underscore.to_sym == role_sym }
end
def ability
  @ability ||= Ability.new(self)
end
  delegate :can?, :cannot?, :to => :ability

end
