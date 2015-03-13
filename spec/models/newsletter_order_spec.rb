# == Schema Information
#
# Table name: newsletter_orders
#
#  id            :integer          not null, primary key
#  student_id    :integer
#  search_params :text
#  created_at    :datetime
#  updated_at    :datetime
#

require 'spec_helper'

describe NewsletterOrder do

  it "does create NewsletterOrders" do
    assert NewsletterOrder.create(student: FactoryGirl.create(:student), search_params: {state: 3}).valid?
  end

  it "does not create NewsletterOrders without student" do
    assert !NewsletterOrder.create(search_params: {state:3}).valid?
  end

  it "does not create NewsletterOrders without search_params" do
    assert !NewsletterOrder.create(student: FactoryGirl.create(:student)).valid?
  end

  it "does create NewsletterOrders with empty Hash" do
    assert NewsletterOrder.create(student: FactoryGirl.create(:student), search_params: {}).valid?
  end
end
