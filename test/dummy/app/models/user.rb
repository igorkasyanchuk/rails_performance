class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable

  # for test purposes
  before_validation do
    self.email = "email#{rand(1000000000)}@email.com"
    self.password = "password"
    self.password_confirmation = "password"
  end

  def say_hello
    sleep(rand(30) / 10.0)
    Rails.logger.info(" ==================" * 10)
    Rails.logger.info(" ~~~~~~~~~~~~~~~~  === hello world" * 10)
    Rails.logger.info(" ==================" * 10)
    User.delay.xxx
  end

  def self.xxx
    Rails.logger.info "========== xxxxxxxxxxxxx ============="
  end

  handle_asynchronously :say_hello
end
