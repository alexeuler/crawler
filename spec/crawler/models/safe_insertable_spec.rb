require 'spec_helper'
require 'crawler/models/safe_insertable'
require 'crawler/models/user_profile'

UserProfile.extend SafeInsertable
UserProfile.unique_id :vk_id

module Crawler
  module Models

    describe SafeInsertable do

      describe "::unique_id" do
        it "specifies unique_id symbol for insert method" do
          UserProfile.instance_variable_get(:@unique_id_symbol).should == :vk_id
        end

      end

      describe "::insert" do
        before(:each) do
        end

        it "inserts models which are not already in db (with respect to unique_id)" do
          models = []
          5.times { models << FactoryGirl.create(:user_profile) }
          4.times {models << FactoryGirl.build(:user_profile)}
          UserProfile.insert(models)
          UserProfile.all.to_a.map(&:vk_id).should == (1..9).to_a
        end
      end

    end

  end
end