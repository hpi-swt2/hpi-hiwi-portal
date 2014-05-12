# == Schema Information
#
# Table name: staffs
#
#  id          :integer          not null, primary key
#  employer_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Staff < ActiveRecord::Base

  has_one :user, as: :manifestation, dependent: :destroy
  belongs_to :employer

  accepts_nested_attributes_for :user, update_only: true

  delegate :firstname, :lastname, :full_name, :email, to: :user

  validates :employer, presence: true

end
