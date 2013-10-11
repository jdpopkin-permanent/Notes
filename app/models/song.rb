class Song < ActiveRecord::Base
  attr_accessible :album_id, :artist_id, :lyrics, :title, :user_id

  validates :title, presence: true
  validates :artist_id, presence: true

  belongs_to :album
  belongs_to :artist
  belongs_to :user

  has_many :notes
  has_many :comments, as: :commentable
  has_many :votes, as: :votable

  # Returns the n songs with the highest scores.
  def self.top(n)
    self.top_with_cutoff(100.years.ago, n)
  end

  def self.recent_top(n)
    self.top_with_cutoff(1.day.ago, n)
  end

  def self.top_with_cutoff(cutoff, n)
    Song.find_by_sql([<<-SQL, cutoff, n])
    SELECT songs.*, SUM(votes.value) AS cached_score FROM songs JOIN votes ON
      (songs.id = votes.votable_id AND votes.votable_type = 'Song')
    WHERE votes.created_at > ?
    GROUP BY songs.id
    ORDER BY SUM(votes.value) DESC LIMIT ?
    SQL
  end

  def cached_score
    attributes["cached_score"]
  end

  def score
    total = 0
    self.votes.each do |vote|
      total += vote.value
    end
    total
  end

  def recent_score
    sum = 0
    self.votes.each do |vote|
      sum += vote.value if vote.created_at > 1.day.ago
    end
    sum
  end

  def as_json(options = {})
    hash = super(options)
    hash["score"] = self.score
    hash
  end
end
