
module RedmineStealth

  LABEL_ACTION_CLOAK     = 'Enable stealth mode'
  LABEL_ACTION_DECLOAK   = 'Disable stealth mode'

  MESSAGE_TOGGLE_FAILED  = 'Failed to toggle stealth mode.'

  DOMID_STEALTH_TOGGLE   = 'stealth_toggle'

  PREF_STEALTH_ENABLED   = :stealth_mode

  module_function

  def cloaked?
    is_cloaked = false
    if my_user = ::User.current
      is_cloaked = true if my_user.pref[PREF_STEALTH_ENABLED]
    end
    is_cloaked
  end

  def set_stealth_mode(is_active)
    if my_user = ::User.current
      user_prefs = my_user.pref
      user_prefs[PREF_STEALTH_ENABLED] = is_active
      user_prefs.save! if user_prefs.changed?
    else
      logger.warn("No user to set stealth mode") if logger
    end
  end

  def cloak!
    set_stealth_mode(true)
  end

  def decloak!
    set_stealth_mode(false)
  end

  def toggle_stealth_mode!
    cloaked? ? decloak! : cloak!
  end

  def toggle_stealth_label
    cloaked? ? LABEL_ACTION_DECLOAK : LABEL_ACTION_CLOAK
  end

end

