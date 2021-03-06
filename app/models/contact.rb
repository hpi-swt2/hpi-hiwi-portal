# == Schema Information
#
# Table name: contacts
#
#  id               :integer          not null, primary key
#  counterpart_id   :integer
#  counterpart_type :string(255)
#  name             :string(255)
#  street           :string(255)
#  zip_city         :string(255)
#  email            :string(255)
#  phone            :string(255)
#  company          :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

class Contact < ApplicationRecord
    belongs_to :counterpart, polymorphic: true, touch: true

    validates :name, :street, :zip_city, :email, presence: true

    def is_empty?
      self.merged.length == 0
    end

    def merged
      [company, name, street, zip_city, email, phone].reject { |x| x.blank?}.join("\n")
    end
end
