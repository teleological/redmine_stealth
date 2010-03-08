
class StealthController < ApplicationController
  unloadable

  before_filter :authorize_global, :only => :toggle

  def toggle
    ::RedmineStealth.toggle_stealth_mode!
    next_toggle_label = ::RedmineStealth.toggle_stealth_label
    toggle_domid      = ::RedmineStealth::DOMID_STEALTH_TOGGLE
    render :update do |page|
      page[toggle_domid].replace_html(next_toggle_label)
    end
  end

end

