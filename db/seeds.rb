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

end