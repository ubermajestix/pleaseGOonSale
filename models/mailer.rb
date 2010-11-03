class Mailer
  class << self
    def default_options(opts={})
      { :address              => 'smtp.gmail.com',
        :port                 => '587',
        :enable_starttls_auto => true,
        :user_name            => opts[:username] || 'welcome@pleasegoonsale.com',
        :password             => opts[:password] || 'pgos1!',
        :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
        :domain               => "pleasegoonsale.com", # the HELO domain provided by the client to the server
        :from                 => opts[:from] || "welcome@pleasegoonsale.com"
      }
    end
    
    def mail(opts={})
      raise 'you need to have someone to send mail to (:to field missing)' unless opts[:to]
      raise 'need to have a message body for this email' unless opts[:html_body]
      Pony.mail(:to => opts[:to], :subject=> opts[:subject] || "Hello!", :html_body => opts[:html_body], :via => :smtp, :via_options => Mailer.default_options(opts))
    end
  end
  
end