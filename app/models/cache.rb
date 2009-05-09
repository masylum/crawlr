class Cache
  def self.get(file)
    if ENV['RAILS_ENV'] == 'development'
      yield
    else
      Rails.cache.fetch(file) do
        return yield
      end
    end
  end
end
