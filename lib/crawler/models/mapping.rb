module Crawler
  module Models
    module Mapping
      def self.user_profile
        {
            item: {
                uid: :vk_id,
                bdate: :birthday,
            },
            single: lambda { |x| x },
            multiple: lambda { |x| x },
            args: {
                fields: "uid,bdate"
            }
        }
      end

      def self.post
        {
            item: {
                id: :vk_id,
                to_id: :owner_id,
                text: :text,
                date: :date,
                copy_owner_id: :copy_owner_id,
                copy_post_id: :copy_post_id,
                likes: {
                    count: :likes_count
                },
                reposts: {
                    count: :reposts_count
                },
                attachment: {
                    type: :attachment_type,
                    video: {
                        vid: :attachment_id,
                        owner_id: :attachment_owner_id,
                        title: :attachment_title,
                        description: :attachment_text,
                        image: :attachment_image
                    },
                    link: {
                        title: :attachment_title,
                        description: :attachment_text,
                        image_src: :attachment_image,
                        url: :attachment_url
                    },
                    photo: {
                        pid: :attachment_id,
                        owner_id: :attachment_owner_id,
                        title: :attachment_title,
                        description: :attachment_text,
                        src: :attachment_image,
                        src_big: :attachment_image
                    }
                }
            },
            single: lambda do |x|
              x.shift
              x
            end,
            args: {count: 100}
        }
      end

      def self.like
        {
            item: :user_profile_id,
            single: lambda { |x| x[:users] },
            args: {
                type: "post"
            }
        }
      end

      def self.friendship
        {
            item: :user_profile_id,
            single: lambda { |x| x },
        }
      end

    end
  end
end