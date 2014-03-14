FactoryGirl.define do
  factory :user_profile do
    sequence(:vk_id) { |n| n }

    factory :user_profile_with_friends do
      ignore do
        friends_count 3
      end
      after(:create) do |user_profile, evaluator|
        friends=FactoryGirl.create_list(:user_profile, evaluator.friends_count)
        user_profile.primary_friends=friends
      end
    end

    factory :user_profile_zolin do
      vk_id 20
      first_name "Sergey"
      last_name "Zolin"
      photo "http://cs315126.vk.me/u20/e_sa5c7sdfb1.jpg"
      sex 2
      birthday Date.new(1987, 2, 28)
      university 2
      faculty 23
      city 1
      country 1
      has_mobile 1
      albums_count 2
      videos_count 14
      audios_count 44
      notes_count 0
      photos_count 17
      groups_count 31
      friends_count 83
      online_friends_count 10
      user_videos_count 0
      followers_count 6
    end

  end
end

module VkResponses
  def self.user_profile_zolin
    [{:uid => 20,
      :first_name => "Sergey",
      :last_name => "Zolin",
      :sex => 2,
      :nickname => "",
      :screen_name => "zolin_sergey",
      :bdate => "28.2.1987",
      :city => "1",
      :country => "1",
      :timezone => 3,
      :photo => "http://cs315126.vk.me/u20/e_sa5c7sdfb1.jpg",
      :photo_medium => "http://cs315126.vk.me/u20/ad_9f71ce4.jpg",
      :photo_big => "http://cs315126.vk.me/u20/va_71v48ea.jpg",
      :has_mobile => 1,
      :online => 1,
      :counters =>
          {:albums => 2,
           :videos => 14,
           :audios => 44,
           :notes => 0,
           :photos => 17,
           :groups => 31,
           :friends => 83,
           :online_friends => 10,
           :user_videos => 0,
           :followers => 6},
      :university => 2,
      :university_name => "LLC",
      :faculty => 23,
      :faculty_name => "MMA",
      :graduation => 2009,
      :education_form => "Day",
      :education_status => "Graduate"}]
  end
end