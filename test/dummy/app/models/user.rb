class User < ApplicationRecord

  def say_hello
    sleep(rand(1.0))
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
