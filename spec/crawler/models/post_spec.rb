require 'spec_helper'
require 'crawler/models/post'

module Crawler
  module Models

    describe UserProfile do
      before(:each) do
        FactoryGirl.reload
        @api = double("api")
        Thread.current[:api] = @api
      end

      describe "::fetch(id)" do
        it 'fetches the wall of user specified by id' do
          @api.stub(:wall_get).and_return([3, VkResponses::zolin_wall(:video),
                                           VkResponses::zolin_wall(:photo), VkResponses::zolin_wall(:link)])
          actual = Post.fetch(1)
          actual[0].attributes.should == FactoryGirl.build(:zolin_wall_video).attributes
          actual[1].attributes.should == FactoryGirl.build(:zolin_wall_photo).attributes
          actual[2].attributes.should == FactoryGirl.build(:zolin_wall_link).attributes
        end

      end

      describe "::load_or_fetch(id)" do
        it "fetches the wall of a user specified by id and loads existing wall posts from db" do
          FactoryGirl.create :post
          @api.should_receive(:wall_get).once do
            [3, {id: 1, to_id: 1}, {id: 2, to_id: 1}, {id: 3, to_id: 2}]
          end
          actual_ids = Post.load_or_fetch(1).map { |post| [post.vk_id, post.owner_id] }
          actual_ids.should == [[1, 1], [2, 1], [3, 2]]
        end
      end

      describe "#fetch_likes" do
        it "fetches user_profiles who liked the post" do
          post = FactoryGirl.create :post
          @api.should_receive(:users_get) do |args|
            args[:uids].should == "1,2,3"
            [{uid: 1}, {uid: 2}, {uid: 3}]
          end
          @api.should_receive(:likes_getList) do |args|
            args[:owner_id].should == 1
            args[:item_id].should == 1
            {users:[1,2,3]}
          end
          post.fetch_likes
          UserProfile.count.should == 3
          post.likes_user_profiles.should == UserProfile.all.to_a
        end
      end

    end

  end
end