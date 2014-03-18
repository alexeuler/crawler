require 'spec_helper'
require 'crawler/models/safe_insertable'
require 'crawler/models/user_profile'
require 'crawler/models/post'

UserProfile.extend SafeInsertable
UserProfile.unique_id :vk_id

Post.extend SafeInsertable
Post.unique_id [:owner_id, :vk_id]


module Crawler
  module Models

    describe SafeInsertable do

      describe "::unique_id" do
        it "specifies unique_id symbol for insert method" do
          UserProfile.instance_variable_get(:@unique_id_symbols).should == [:vk_id]
        end

      end

      describe "::insert" do
        it "inserts models which are not already in db (with respect to unique_id)" do
          models = []
          5.times { models << FactoryGirl.create(:user_profile) }
          4.times { models << FactoryGirl.build(:user_profile) }
          UserProfile.count.should == 5

          actual=UserProfile.insert(models)
          expected=UserProfile.all.load
          actual.should == expected
          UserProfile.all.to_a.map(&:vk_id).should == (1..9).to_a

          models = []
          5.times { models << FactoryGirl.create(:post) }
          4.times { models << FactoryGirl.build(:post) }
          Post.count.should == 5
          actual = Post.insert(models)
          expected = Post.all.load
          actual.should == expected
          ids = Post.all.to_a.map do |post|
            [post.owner_id, post.vk_id]
          end
          ids.should == [[1, 1], [1, 2], [1, 3], [2, 1], [2, 2], [2, 3], [3, 1], [3, 2], [3, 3]]
        end
      end

    end

  end
end