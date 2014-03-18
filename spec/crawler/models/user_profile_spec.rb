require 'spec_helper'
require 'crawler/models/user_profile'

module Crawler
  module Models

    describe UserProfile do
      before(:each) do
        FactoryGirl.reload
        @api = double("api")
        Thread.current[:api] = @api
      end

      describe "::fetch(ids)" do
        it 'fetches user profile from vk and returns user_profile_model' do
          expected = FactoryGirl.build(:user_profile_zolin)
          @api.stub(:users_get).and_return VkResponses::user_profile_zolin
          actual = UserProfile.fetch(1)
          actual.attributes.should == expected.attributes
        end

      end

      describe "::load_or_fetch(ids)" do
        it "loads users from db and fetches the rest via vk api" do
          users = []
          5.times { users << FactoryGirl.create(:user_profile) }
          @api.should_receive(:users_get).once do |args|
            args[:uids].should == (6..9).to_a.join(",")
            []
          end
          UserProfile.load_or_fetch (1..9).to_a
        end
      end

      describe "#fetch_friends" do
        it "fetches friends and saves corresponding UserProfiles in db" do
          user = FactoryGirl.create :user_profile_with_friends
          inv_friend = FactoryGirl.create :user_profile
          user.inverse_friends = [inv_friend]
          @api.should_receive(:friends_get) do
            response = []
            response << UserProfile.all.to_a[1]
            response << UserProfile.last
            response << FactoryGirl.build(:user_profile, vk_id: 999)
            response.map(&:vk_id)
          end
          @api.should_receive(:users_get) do |args|
            args[:uids].should == "999"
            [{uid: 999}]
          end
          user.fetch_friends
          UserProfile.select(:vk_id).to_a.map(&:vk_id).should == [1, 2, 3, 4, 5, 999]
        end
      end

    end

  end
end