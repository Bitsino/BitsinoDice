class Secret < ActiveRecord::Base

  belongs_to :bet

  before_create :generate_secret

  def to_s
    created_at < 24.hours.ago ? secret : '************************************'
  end

  protected

    def generate_secret
      self.secret = SecureRandom.hex(64)
    end
end
