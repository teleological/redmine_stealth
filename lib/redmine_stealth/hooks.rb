
module RedmineStealth
  class Hooks < Redmine::Hook::ViewListener

    def controller_account_success_authentication_after(context={})
      ::RedmineStealth.decloak!
    end

    def view_layouts_base_html_head(context={})
      stylesheet_link_tag('stealth', :plugin => 'redmine_stealth')
    end

    def view_layouts_base_body_bottom(context={})
      is_cloaked = RedmineStealth.cloaked?
      init_state = RedmineStealth.javascript_toggle_statement(is_cloaked)

      js_lib = 'stealth'
      javascript_include_tag(js_lib, :plugin => 'redmine_stealth') +
        javascript_tag("jQuery(function($) { #{init_state} });")
    end

  end
end

