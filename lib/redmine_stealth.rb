
module RedmineStealth

  include Redmine::I18n

  PREF_STEALTH_ENABLED   = :stealth_mode

  MESSAGE_ACTION_CLOAK   = 'enable_stealth_mode'
  MESSAGE_ACTION_DECLOAK = 'disable_stealth_mode'
  MESSAGE_TOGGLE_FAILED  = 'failed_to_toggle_stealth_mode'

  module_function

  def cloaked?
    current_user = ::User.current
    !! (current_user && current_user.pref[PREF_STEALTH_ENABLED])
  end

  def status_label(is_cloaked)
    is_cloaked ? l(MESSAGE_ACTION_DECLOAK) : l(MESSAGE_ACTION_CLOAK)
  end

  def toggle_stealth_mode!
    is_cloaked = cloaked?
    is_cloaked ? decloak! : cloak!
  end

  def cloak!
    set_stealth_mode(true)
  end

  def decloak!
    set_stealth_mode(false)
  end

  def set_stealth_mode(is_cloaked)
    if current_user = ::User.current
      user_prefs = current_user.pref
      user_prefs[PREF_STEALTH_ENABLED] = is_cloaked
      user_prefs.save! if user_prefs.changed?
      is_cloaked
    else
      logger.warn("No user to set stealth mode") if logger
    end
  end

  def javascript_toggle_statement(is_cloaked)
    label = status_label(is_cloaked)
    method = "RedmineStealth.#{ is_cloaked ? 'cloak' : 'decloak' }"
    "#{method}('#{label}');"
  end

end

