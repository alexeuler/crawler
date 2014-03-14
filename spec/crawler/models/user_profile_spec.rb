require 'spec_helper'
require 'crawler/models/user_profile'

module Crawler
  module Models

    describe UserProfile do

      describe "::fetch" do
        before(:each) do

        end

        it 'fetches user profile from vk and returns user_profile_model' do
          expected = FactoryGirl.build(:user_profile_zolin)
          api = Thread.current[:api]
          api.stub(:users_get).and_return VkResponses::user_profile_zolin
          actual = UserProfile.fetch(1)
          actual.attributes.should == expected.attributes
        end
      end

    end

  end
end