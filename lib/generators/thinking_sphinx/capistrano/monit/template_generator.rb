module ThinkingSphinx
  module Capistrano
    module Monit
      module Generators
        class TemplateGenerator < Rails::Generators::Base

          namespace "thinking_sphinx:capistrano:monit:template"
          desc "Create local monitrc.erb, and erb files for monitored processes for customization"
          source_root File.expand_path('../../../../../thinking_sphinx/capistrano/templates', __FILE__)
          argument :templates_path, type: :string,
            default: "config/deploy/templates",
            banner: "path to templates"

          def copy_template
            copy_file "ts_monit.conf.erb", "#{templates_path}/ts_monit.erb"
          end

        end
      end
    end
  end
end
