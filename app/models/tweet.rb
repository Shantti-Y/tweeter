class Tweet < ApplicationRecord
  belongs_to :user

  validates :content, presence: true,
                      length: { maximum: 140 }
  validates :user_id, presence: true

  def tweeted_at
    return self.created_at.strftime("%m/%d  %H:%M")
=begin
    if tweeted_at < 60
      return "#{tweeted_at}s"
    elsif tweeted_at / 60 < 60
      return "#{tweeted_at % 60}m"
    elsif tweeted_at / (60 * 60) < 24
      return "#{tweeted_at % (60 * 60)}h"
    elsif tweeted_at / (60 * 60 * 24) < 10
      return  "#{tweeted_at / (60 * 60 * 24)}d"
    else
      return Time.at(tweeted_at).strftime("%M %D")
    end
=end
  end
end
