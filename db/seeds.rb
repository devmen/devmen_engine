User.create :name => 'admin', :password => 'admin', :email => 'admin@devmen.ru', :roles => ['admin']

if ['development', 'test'].include? Rails.env
  # Create some pages
  Page.destroy_all
  5.times do |i|
    attrs = {
      :name => Faker::Lorem.words(rand(2..3)).join(' ').capitalize,      
      :body => "<h1>#{Faker::Lorem.sentence}</h1><p>#{Faker::Lorem.paragraphs(rand(3..10)).join(' ')}</p>"
    }
    attrs[:url] = Faker::Lorem.words(rand(2..3)).join('-').downcase if i.odd?
    Page.create(attrs)
  end

  # Create some news
  if News.present?
    News::Entry.destroy_all
    5.times do |i|
      attrs = {
        :name => Faker::Lorem.words(rand(2..3)).join(' ').capitalize,
        :date => Time.new - rand(0..30).days,
        :text => "<h1>#{Faker::Lorem.sentence}</h1><p>#{Faker::Lorem.paragraphs(rand(3..10)).join(' ')}</p>"
      }
      News::Entry.create(attrs)
    end
  end

  # Create some realty
  if Realty.present?
    Realty::Entry.destroy_all
    5.times do |i|
      attrs = {
        :name => Faker::Lorem.words(rand(2..3)).join(' ').capitalize,
        :price => rand(5000000),
        :address => "<h1>#{Faker::Lorem.sentence}</h1><p>#{Faker::Lorem.paragraphs(rand(3..10)).join(' ')}</p>",
        :description => "<h1>#{Faker::Lorem.sentence}</h1><p>#{Faker::Lorem.paragraphs(rand(3..10)).join(' ')}</p>"
      }
      Realty::Entry.create(attrs)
    end
  end

  # Create shop module fake data
  if Shop.present?
    # Create fake categories
    Shop::Category.destroy_all
    attrs = -> do
      {
        :name => Faker::Lorem.words(rand(2..3)).join(' ').capitalize,
        :description => Faker::Lorem.sentences(rand(2..3))
      }
    end
    3.times do
      category = Shop::Category.create(attrs)
      rand(5).times { Shop::Category.create(attrs.merge :parent_id => category.id) }
    end

    # Create fake products
    Shop::Product.destroy_all
    attrs = -> do
      {
        :name => Faker::Lorem.words(rand(2..3)).join(' ').capitalize,
        :description => Faker::Lorem.sentences(rand(2..3)),
        :sku => Faker::Lorem.numerify('########'),
        :price => (rand(100) + rand).round(2)
        :old_price => (rand(100) + rand).round(2)
        :in_stock => rand(10)
      }
    end
    categories = Shop::Category.all
    20.times do
      category = nil
      while !category do
        category = categories[rand(categories.length)]
        category = nil if category.parent_id == 0 and rand(100) >= 10
      end
      3.times { Shop::Product.create(attrs.merge :parent_id => category.id) }
      3.times { Shop::Product.create(attrs) } # orphaned products
    end

    # Create fake orders
  end

end