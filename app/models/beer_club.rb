class BeerClub < ActiveRecord::Base
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :confirmed_memberships, -> { confirmed }, class_name: 'Membership'
  has_many :pending_memberships, -> { pending }, class_name: 'Membership'
  has_many :confirmed_members, through: :confirmed_memberships, source: :user
  has_many :pending_members, through: :pending_memberships, source: :user

  def to_s
    name
  end
end
