require_dependency 'application_helper'

module StealthCssHelper
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)

    base.class_eval do
      unloadable
      alias_method_chain :body_css_classes, :stealth
    end
  end

  module InstanceMethods
    def body_css_classes_with_stealth
     if ::RedmineStealth.cloaked?
       body_css_classes_without_stealth += ' stealth_on'
     else
       body_css_classes_without_stealth += ' stealth_off'
     end
    end
  end
end
