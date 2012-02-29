module RedmineStealth
  class Hooks < Redmine::Hook::ViewListener
    def controller_account_success_authentication_after(context={})
      # on login decloak
      ::RedmineStealth.decloak!
    end

    def view_layouts_base_html_head(context={})
      javascript_include_tag 'stealth.js',
        :plugin => 'redmine-stealth-plugin'
    end
  end
end
