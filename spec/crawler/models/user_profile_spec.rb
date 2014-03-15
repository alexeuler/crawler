require 'spec_helper'
require 'crawler/models/user_profile'

module Crawler
  module Models

    describe UserProfile do

      describe "::fetch" do
        before(:each) do
          @api = Thread.current[:api]
        end

        it 'fetches user profile from vk and returns user_profile_model' do
          expected = FactoryGirl.build(:user_profile_zolin)
          @api.stub(:users_get).and_return VkResponses::user_profile_zolin
          actual = UserProfile.fetch(1)
          actual.attributes.should == expected.attributes
        end

      end

      describe "load_or_fetch" do
        before(:each) do

        end

        it "loads users from db and fetches the rest via vk api" do
          users = []
          5.times {users << FactoryGirl.create(:user_profile)}

        end

      end

    end

  end
end