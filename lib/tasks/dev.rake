namespace :dev do

  task fake_user: :environment do
    User.where.not(role: "admin").destroy_all
    20.times do
      username = FFaker::Name.unique.last_name
      User.create!(
        name: username,
        email: "#{username}@example.com",
        password: "12345678",
        avatar: File.open(Rails.root.join("public/avatar/user#{rand(1..20)}.jpg")),
        intro: FFaker::Lorem.paragraphs
      )
    end
    puts "created fake users"
    puts "now you have #{User.count} users data"
  end

  task fake_post: :environment do
    Post.destroy_all

    100.times do
      user = User.all.sample
      post = user.posts.build(
        title: FFaker::Book.unique.author,
        content: FFaker::Book.description,
        image: File.open(Rails.root.join("public/image/image#{rand(1..20)}.jpg")),
        status: ["draft", "public", "public", "draft"].sample,
        authority: ["myself", "friend", "all"].sample
      )
      post.save
      post.category_posts.create(category: Category.all.sample)
    end
    puts "have created fake posts"
    puts "now you have #{Post.count} posts data"
  end

  task fake_comment: :environment do
    Comment.destroy_all
    200.times do
      user = User.all.sample
      post = Post.are_viewable?(user).are_public?.sample
      post.comments.create!(
        user: user,
        content: FFaker::Lorem.sentence
      )
      unless post.seen_by?(user)
        post.vieweds.create( user: user )
      end
    end
    puts "created fake comments"
    puts "now you have #{Comment.count} comments data"
  end

  task fake_collect: :environment do
    100.times do
      user = User.all.sample
      post = Post.are_viewable?(user).are_public?.sample
      unless post.is_collected?(user)
        post.collections.create(user: user)
      end
    end
    puts "created fake collections"
    puts "now you have #{Collection.count} collections data"
  end

  task fake_friend: :environment do
    60.times do
      user1 = User.all.sample
      user2 = User.where.not(id: user1.id).sample
      unless user1.request_friend?(user2) || user1.inverse_request_friend?(user2)
        user1.request_friendships.create!(friend: user2)
        puts "#{user1.name} invite #{user2.name}"
      end
    end
    30.times do
      friendship = Friendship.where(status: false).sample
      friendship.update(status: true)
      puts "#{friendship.user_id} accept friend to #{friendship.friend_id}"
    end
  end

end