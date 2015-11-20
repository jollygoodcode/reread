require 'rails_helper'

RSpec.describe PocketDecorator do
  let(:decorator) { PocketDecorator.new(pocket)}

  context 'general' do
    let(:pocket) do
      Pocket.create!(
        raw: {
          'item_id'        => '885500',
          'resolved_title' => 'Google',
          'time_added'     => 1447516800,
        }
      )
    end

    describe '#created_on' do
      it 'adjusts to SGT time zone' do
        result = decorator.created_on('Singapore')
        expect(result).to eq '15 Nov 2015'
      end

      it 'adjusts to EST time zone' do
        result = decorator.created_on('Eastern Time (US & Canada)')
        expect(result).to eq '14 Nov 2015'
      end
    end

    describe '#given_url' do
      it { expect(decorator.given_url).to eq 'https://getpocket.com/a/read/885500' }
    end

    describe '#resolved_title' do
      it { expect(decorator.resolved_title).to eq 'Google' }
    end
  end

  describe '#image' do
    context 'when image exists' do
      let(:pocket) do
        Pocket.create!(
          raw: {
            'image' => { 'src' => 'https://google.com/image' }
          }
        )
      end

      it { expect(decorator.image).to eq 'https://google.com/image' }
    end

    context 'when image does not exist' do
      let(:pocket) { Pocket.create! }

      it { expect(decorator.image).to eq 'https://placeholdit.imgix.net/~text?txtsize=30&txt=reread.io&w=150&h=150' }
    end
  end

  describe '#authors' do
    context 'when authors exists' do
      let(:pocket) do
        Pocket.create!(
          raw: {
            'authors' => { '1' => { 'name' => 'Naruto' }, '2' => { 'name' => 'Sasuke' } }
          }
        )
      end

      it { expect(decorator.authors).to eq 'Naruto, Sasuke' }
    end

    context 'when authors does not exist' do
      let(:pocket) { Pocket.create! }

      it { expect(decorator.authors).to be_nil }
    end
  end

  describe '#excerpt' do
    context 'when pocket is an article' do
      let(:pocket) do
        Pocket.create!(
          raw: {
            'is_article' => '1',
            'excerpt' => 'Short Description'
          }
        )
      end

      it { expect(decorator.excerpt).to eq 'Short Description' }
    end

    context 'when pocket is not an article' do
      let(:pocket) do
        Pocket.create!(
          raw: {
            'is_article' => '0'
          }
        )
      end

      it { expect(decorator.excerpt).to eq 'This is a video or image. No description available.' }
    end
  end

  describe '#word_count' do
    context 'when pocket is an article' do
      let(:pocket) do
        Pocket.create!(
          raw: {
            'is_article' => '1',
            'word_count' => '1234'
          }
        )
      end

      it { expect(decorator.word_count).to eq 1234 }
    end

    context 'when pocket is not an article' do
      let(:pocket) do
        Pocket.create!(
          raw: {
            'is_article' => '0'
          }
        )
      end

      it { expect(decorator.word_count).to eq 0 }
    end
  end
end
