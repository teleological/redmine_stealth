
require 'redmine'
require 'redmine/i18n'

require 'redmine_stealth'
require 'redmine_menu_manager_extensions'

if Rails::VERSION::MAJOR >= 3
  require 'stealth_mail_interceptor'
else
  require 'action_mailer_base_extensions'
end

require 'stealth_hooks'

Redmine::Plugin.register :redmine_stealth do

  extend Redmine::I18n

  name        'Redmine Stealth plugin'
  author      'Riley Lynch'
  description 'Enables users to disable Redmine email notifications ' +
              'for their actions'
  version     '0.5.0'

  if respond_to?(:url)
    url 'http://teleological.github.com/redmine-stealth-plugin'
  end
  if respond_to?(:author_url)
    author_url 'http://github.com/teleological'
  end

  permission :toggle_stealth_mode, :stealth => :toggle

  decide_toggle_display =
    lambda do |*_|
      show_toggle = false
      if my_user = ::User.current
        toggle_action = {:controller => 'stealth', :action => 'toggle'}
        if my_user.allowed_to?(toggle_action,nil,:global => true)
          show_toggle = true
        end
      end
      show_toggle
    end

  stealth_menuitem_captioner =
    lambda { |project| ::RedmineStealth.toggle_stealth_label }

  menu :account_menu, :stealth,
    { :controller => 'stealth', :action => 'toggle' },
    :first    => true,
    :if       => decide_toggle_display,
    :caption  => stealth_menuitem_captioner,
    :html     => {
      :id => ::RedmineStealth::DOMID_STEALTH_TOGGLE,
    },
    :remote   => {
      :failure => "alert('#{l(::RedmineStealth::MESSAGE_TOGGLE_FAILED)}')",
    }
end

require 'application_helper'
require 'stealth_css_helper'

stealth_css_helper_mixin = lambda do |*_|
  unless ApplicationHelper.included_modules.include?(StealthCssHelper)
    ApplicationHelper.send(:include, StealthCssHelper)
  end
end

if Rails::VERSION::MAJOR >= 3
  ActionDispatch::Callbacks.to_prepare(&stealth_css_helper_mixin)
else
  require 'dispatcher'
  Dispatcher.to_prepare(&stealth_css_helper_mixin)
end

