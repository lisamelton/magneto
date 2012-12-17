class Hash

  # Copied from `active_support/core_ext/hash/keys.rb` with thanks to David
  # Heinemeier Hansson and contributors.

  # Return a new hash with all keys converted to strings.
  def stringify_keys
    dup.stringify_keys!
  end

  # Destructively convert all keys to strings.
  def stringify_keys!
    keys.each do |key|
      self[key.to_s] = delete(key)
    end
    self
  end

  # Return a new hash with all keys converted to symbols, as long as
  # they respond to +to_sym+.
  def symbolize_keys
    dup.symbolize_keys!
  end

  # Destructively convert all keys to symbols, as long as they respond
  # to +to_sym+.
  def symbolize_keys!
    keys.each do |key|
      self[(key.to_sym rescue key) || key] = delete(key)
    end
    self
  end

  # Adapted from `jekyll/core_ext.rb` with thanks to Tom Preston-Werner.

  # Merges self with another hash, recursively.
  #
  # This code was lovingly stolen (now adapted) from some random gem:
  # http://gemjack.com/gems/tartan-0.1.1/classes/Hash.html
  #
  # Thanks to whoever made it.
  def deep_merge(hash)
    dup.deep_merge! hash
  end

  def deep_merge!(hash)
    hash.keys.each do |key|
      if hash[key].is_a? Hash and self[key].is_a? Hash
        self[key] = self[key].deep_merge(hash[key])
        next
      end

      self[key] = hash[key]
    end

    self
  end
end
