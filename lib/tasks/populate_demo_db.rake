namespace :demo do
  namespace :fill do
    RECORDS_COUNT = 5
    REALTY_CATEGORIES = 3
    REALTIES = 4
    REALTY_PHOTOS = 3
    REALTY_IMAGES = %w[1.jpg 2.jpg 3.jpg 4.jpg 5.jpg 6.jpg]

    SHOP_CATEGORIES = 3
    SHOP_SUBCATEGORIES = 3
    SHOP_PRODUCTS = 6
    PRODUCTS_PHOTOS = %w[1.jpg 2.jpg 3.jpg 4.jpg 5.jpg 6.jpg 7.jpg 8.jpg 9.jpg 10.jpg 11.jpg 12.jpg]
    PHOTOS_COUNT = 2

    PAGES = %w[about contacts]

    desc "Fill the all demo data"
    task all: :environment do
      Rake::Task["demo:fill:users"].invoke
      Rake::Task["demo:fill:contact_us"].invoke
      Rake::Task["demo:fill:pages"].invoke
      Rake::Task["demo:fill:review"].invoke
      Rake::Task["demo:fill:news"].invoke if CFG["modules"].include?("news")
      Rake::Task["demo:fill:realty"].invoke if CFG["modules"].include?("realty")
      Rake::Task["demo:fill:shop"].invoke if CFG["modules"].include?("shop")
    end

    desc "Fill the demo data with users"
    task users: :environment do
      puts "== Filling with users ".ljust(72, "=")
      ActiveRecord::Base.connection.execute("TRUNCATE users")
      login = CFG["demo"]["admin"]["login"] rescue 'admin'
      password = CFG["demo"]["admin"]["password"] rescue 'admin'
      email = CFG["demo"]["admin"]["email"] rescue 'admin@devmen.ru'
      User.create name: login, password: password, email: email, roles: ['admin']
    end

    desc "Fill the demo data with news"
    task news: :environment do
      puts "== Filling with news ".ljust(72, "=")
      %w[news news_categories].each do |table|
        ActiveRecord::Base.connection.execute("TRUNCATE #{table}")
      end

      category_one = News::Category.create name: Faker::Internet.domain_name
      category_two = News::Category.create name: Faker::Internet.domain_name
      [category_one, category_two].each do |category|
        RECORDS_COUNT.times do
          attrs = {
            :name => Faker::Lorem.words(rand(2..3)).join(' ').capitalize,
            :date => Time.new - rand(0..30).days,
            :text => "<h1>#{Faker::Lorem.sentence}</h1><p>#{Faker::Lorem.paragraphs(rand(3..10)).join(' ')}</p>"
          }
          category.news.create(attrs)
        end
      end
    end

    desc "Fill the demo data with realty"
    task realty: :environment do
      puts "== Filling with realty ".ljust(72, "=")
      Realty::Photo.all.each { |photo| photo.remove_image! }
      %w[realty realty_categories realty_photos].each do |table|
        ActiveRecord::Base.connection.execute("TRUNCATE #{table}")
      end

      REALTY_CATEGORIES.times do
        category = Realty::Category.create name: Faker::Internet.domain_name
        REALTIES.times do
          attrs = {
            :name => Faker::Lorem.words(rand(2..3)).join(' ').capitalize,
            :price => rand(5000000),
            :address => "<h1>#{Faker::Lorem.sentence}</h1><p>#{Faker::Lorem.paragraphs(rand(3..10)).join(' ')}</p>",
            :description => "<h1>#{Faker::Lorem.sentence}</h1><p>#{Faker::Lorem.paragraphs(rand(3..10)).join(' ')}</p>"
          }
          realty = category.realties.create attrs

          REALTY_PHOTOS.times do
            photo = realty.photos.new
            photo.image = File.open("#{Rails.root}/demo_data/realty_images/#{REALTY_IMAGES.sample}")
            photo.save
          end
        end
      end
    end

    desc "Fill the demo data with products"
    task shop: :environment do
      puts "== Filling with shop ".ljust(72, "=")
      Shop::Picture.all.each { |picture| picture.remove_image! }
      %w[friendly_id_slugs carts orders product_categories product_items product_pictures products].each do |table|
        ActiveRecord::Base.connection.execute("TRUNCATE #{table}")
      end

      SHOP_CATEGORIES.times do
        attrs = {
          name: Faker::Lorem.words(rand(2..3)).join(' ').capitalize,
          description: Faker::Lorem.sentences(rand(2..3))
        }
        category = Shop::Category.create(attrs)

        attrs = {
          name: Faker::Lorem.words(rand(2..3)).join(' ').capitalize,
          description: Faker::Lorem.sentences(rand(2..3)),
          parent_id: category.id
        }
        rand(SHOP_SUBCATEGORIES).times { Shop::Category.create(attrs) }
      end

      categories = Shop::Category.all
      20.times do
        category = nil
        while !category do
          category = categories[rand(categories.length)]
          category = nil if category.parent_id == 0 and rand(100) >= 10
        end

        SHOP_PRODUCTS.times do |i|
          attrs = {
            :name => Faker::Lorem.words(rand(2..3)).join(' ').capitalize,
            :description => Faker::Lorem.sentences(rand(2..3)),
            :sku => Faker::Lorem.numerify('########'),
            :price => (rand(100) + rand).round(2),
            :old_price => (rand(100) + rand).round(2),
            :in_stock => rand(10)
          }

          product_attrs = i < SHOP_PRODUCTS / 2 ? attrs.merge({category_id: category.id}) : attrs
          product = Shop::Product.create(product_attrs)
          PHOTOS_COUNT.times do
            photo = product.pictures.new
            photo.image = File.open("#{Rails.root}/demo_data/product_photos/#{PRODUCTS_PHOTOS.sample}")
            photo.save
          end
        end
      end

    end

    desc "Fill the demo with contact us data"
    task contact_us: :environment do
      puts "== Filling with contact us ".ljust(72, "=")
      %w[contact_us_entries].each do |table|
        ActiveRecord::Base.connection.execute("TRUNCATE #{table}")
      end

      RECORDS_COUNT.times do
        ContactUs::Entry.create(name: [Faker::Name.first_name, Faker::Name.last_name].join(" "),
                                email: Faker::Internet.email,
                                phone: Faker::PhoneNumber.phone_number,
                                content: Faker::Lorem.paragraph)
      end
    end

    desc "Fill the demo with pages data"
    task pages: :environment do
      puts "== Filling with custom pages ".ljust(72, "=")
      %w[pages].each do |table|
        ActiveRecord::Base.connection.execute("TRUNCATE #{table}")
      end

      PAGES.each do |page|
        Page.create name: page.capitalize,
                    body: "<h1>#{Faker::Lorem.sentence}</h1><p>#{Faker::Lorem.paragraphs(rand(3..10)).join(' ')}</p>",
                    url: page
      end
    end

    desc "Fill the demo with review data"
    task review: :environment do
      puts "== Filling with review ".ljust(72, "=")
      %w[review_entries].each do |table|
        ActiveRecord::Base.connection.execute("TRUNCATE #{table}")
      end

      RECORDS_COUNT.times do
        full_name = [Faker::Name.first_name, Faker::Name.last_name].join(" ")
        Review::Entry.create name: full_name, content: Faker::Lorem.paragraph, visible: true
      end
    end
  end
end
