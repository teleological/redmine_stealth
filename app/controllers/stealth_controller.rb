
class StealthController < ApplicationController

  unloadable

  before_filter :authorize_global, :only => :toggle

  def toggle
    is_cloaked = toggle_for_params
    render :js => RedmineStealth.javascript_toggle_statement(is_cloaked)
  end

  private

  def toggle_for_params
    if params[:toggle] == 'true'
      RedmineStealth.cloak!
    elsif params[:toggle] == 'false'
      RedmineStealth.decloak!
    else
      RedmineStealth.toggle_stealth_mode!
    end
  end

end

