
require 'redmine'
require 'redmine/i18n'

require 'redmine_stealth'

unless RedmineStealth::USE_UJS
  require 'redmine_ext/menu_manager_extensions'
end

if Rails::VERSION::MAJOR >= 3
  require 'redmine_stealth/mail_interceptor'
else
  require 'action_mailer_ext/base_extensions'
end

require 'redmine_stealth/hooks'

Redmine::Plugin.register :redmine_stealth do

  extend Redmine::I18n

  plugin_locale_glob = respond_to?(:directory) ?
    File.join(directory, 'config', 'locales', '*.yml') :
    File.join(Rails.root, 'vendor', 'plugins',
              'redmine_stealth', 'config', 'locales', '*.yml')

  ::I18n.load_path += Dir.glob(plugin_locale_glob)

  menu_options = {
    :html => {
      'id' => 'stealth_toggle',
      'data-failure-message' => l(RedmineStealth::MESSAGE_TOGGLE_FAILED)
    }
  }

  name        'Redmine Stealth plugin'
  author      'Riley Lynch'
  description 'Enables users to disable Redmine email notifications ' +
              'for their actions'
  version     '0.6.0'

  if respond_to?(:url)
    url 'http://teleological.github.com/redmine-stealth-plugin'
  end
  if respond_to?(:author_url)
    author_url 'http://github.com/teleological'
  end

  permission :toggle_stealth_mode, :stealth => :toggle

  toggle_url = { :controller => 'stealth', :action => 'toggle' }

  decide_toggle_display = lambda do |*_|
    can_toggle = false
    if user = ::User.current
      can_toggle = user.allowed_to?(toggle_url, nil, :global => true)
    end
    can_toggle
  end

  stealth_menuitem_captioner = lambda do |project|
    is_cloaked = RedmineStealth.cloaked?
    RedmineStealth.status_label(is_cloaked)
  end

  if RedmineStealth::USE_UJS
    menu_options[:html].update('remote' => true, 'method' => :post)
  else
    menu_options[:remote] = {
      :method => :post,
      :failure => 'RedmineStealth.notifyFailure();',
      :with => %q{(function() {
        var $toggle = $('stealth_toggle');
        var params = $toggle.readAttribute('data-params-toggle');
        return params ? ('toggle=' + params) : '';
      })()}
    }
  end

  menu :account_menu, :stealth, toggle_url, {
    :first    => true,
    :if       => decide_toggle_display,
    :caption  => stealth_menuitem_captioner
  }.merge(menu_options)

end

