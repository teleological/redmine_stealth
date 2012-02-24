module RedmineStealth
  class Hooks < Redmine::Hook::ViewListener
    def controller_account_success_authentication_after(context={ })
      # on login decloak
      ::RedmineStealth.decloak!
    end
  end
end
