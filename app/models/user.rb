class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_and_belongs_to_many :roles
  has_many :items, inverse_of: :user
  belongs_to :department
  has_paper_trail :ignore => [:updated_at]
validates :department, presence: true
def has_role?(role_sym)
  roles.any? { |r| r.name.underscore.to_sym == role_sym }
end
def ability
  @ability ||= Ability.new(self)
end
  delegate :can?, :cannot?, :to => :ability

end
