module AppboxOctopress
  module Utilities
    PLUGINS_DIR = File.expand_path(File.dirname(__FILE__) + '/../../templates/plugins')
    CSS_DIR = File.expand_path(File.dirname(__FILE__) + '/../../templates/css')

    def self.install
      FileUtils.copy_file plugin_path, plugin_destination
      FileUtils.copy_file css_path, css_destination
      add_stylesheet
    end

    def self.remove
      FileUtils.rm plugin_destination
      FileUtils.rm css_destination
    end

    protected

    def self.plugin_path
      File.join(PLUGINS_DIR, 'appbox.rb')
    end

    def self.plugin_destination
      File.join(Dir.pwd, 'plugins', 'appbox.rb')
    end

    def self.css_path
      File.join(CSS_DIR, 'appbox.css')
    end

    def self.css_destination
      File.join(Dir.pwd, 'source', 'stylesheets', 'appbox.css')
    end

    def self.add_stylesheet
      File.open('source/_includes/custom/head.html', 'a') { |file| file << "<link href=\"{{ root_url }}/stylesheets/appbox.css\" media=\"screen, projection\" rel=\"stylesheet\" type=\"text/css\">\n"}
    end
  end
end
