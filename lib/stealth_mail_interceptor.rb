
# Rails >= 3

class StealthMailInterceptor
  def self.delivering_email(msg)
    if ::RedmineStealth.cloaked?
      msg.perform_deliveries = false
      if logger = ActionMailer::Base.logger
        logger.info("Squelching notification: #{msg.subject}")
      end
    end
  end
end

ActionMailer::Base.register_interceptor(StealthMailInterceptor)

