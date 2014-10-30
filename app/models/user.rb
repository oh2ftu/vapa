class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_and_belongs_to_many :roles
  has_and_belongs_to_many :groups
  has_many :items, inverse_of: :user
  has_many :comments
  belongs_to :department
  has_paper_trail :ignore => [:updated_at]
validates :department, presence: true
def to_label_sms
  "#{firstname} #{lastname}"
end
def has_role?(role_sym)
  roles.any? { |r| r.name.underscore.to_sym == role_sym }
end
def ability
  @ability ||= Ability.new(self)
end
  delegate :can?, :cannot?, :to => :ability

end
