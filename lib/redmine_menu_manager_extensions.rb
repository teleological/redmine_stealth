
module RedmineMenuManagerExtensions
end

require 'redmine/menu_manager'

module Redmine
  module MenuManager
    class MenuItem
      attr_reader :remote
      def initialize_with_remote_option(name,url,options)
        if remote_options = options.delete(:remote)
          remote_options = {} unless remote_options.kind_of?(::Hash)
          @remote = remote_options
          initialize_without_remote_option(name,url,options)
        else
          @remote = nil
          initialize_without_remote_option(name,url,options)
        end
      end
      alias_method_chain :initialize, :remote_option
    end
    module MenuHelper
      def render_single_menu_node_with_remote_option(item,caption,url,selected)
        if user_remote_options = item.remote
          remote_options  = { :url => url }
          remote_options.update(user_remote_options)
          html_options = item.html_options(:selected => selected)
          link_to_remote(h(caption), remote_options, html_options)
        else
          render_single_menu_node_without_remote_option(item,
                                                        caption,url,selected)
        end
      end
      alias_method_chain :render_single_menu_node, :remote_option
    end
  end
end

