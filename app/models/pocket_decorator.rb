class PocketDecorator < SimpleDelegator

  def created_on(time_zone)
    Time.at(raw['time_added'].to_i).in_time_zone(time_zone).strftime('%e %b %Y')
  end

  def image
    if raw['image'].blank?
      'https://placeholdit.imgix.net/~text?txtsize=30&txt=reread.io&w=150&h=150'
    else
      raw['image']['src']
    end
  end

  def given_url
    raw['given_url']
  end

  def resolved_title
    raw['resolved_title'].presence || raw['given_title'].presence || 'No Title'
  end

  def authors
    return nil if raw['authors'].blank?

    raw['authors'].values.map { |author| author['name'] }.join(', ')
  end

  def excerpt
    if raw['is_article'] == '1'
      raw['excerpt']
    else
      'This is a video or image. No description available.'
    end
  end

  def word_count
    if raw['is_article'] == '1'
      raw['word_count'].to_i
    else
      0
    end
  end

  def minutes_to_read # 200 wpm for average readers
    word_count / 200
  end
end
