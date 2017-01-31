require 'thinking-sphinx'

namespace :load do
  task :defaults do
    set :thinking_sphinx_monit_conf_dir, -> { "/etc/monit/conf.d/#{thinking_sphinx_monit_service_name}.conf" }
    set :thinking_sphinx_use_sudo, true
    set :thinking_sphinx_monit_bin, '/usr/bin/monit'
  end
end

namespace :thinking_sphinx do
  namespace :monit do
    desc 'Config Thinking Sphinx monit-service'
    task :config do
      on roles(fetch(:thinking_sphinx_roles)) do |role|
        within current_path do
          with rails_env: fetch(:thinking_sphinx_rails_env) do
            @searchd = searchd
            @config_path = config.configuration_file
            @ts_pid_file = config.searchd.pid_file
            @role = role
            template_crono 'ts_monit.conf', "#{fetch(:tmp_dir)}/ts_monit.conf"
            sudo_if_needed "mv #{fetch(:tmp_dir)}/ts_monit.conf #{fetch(:thinking_sphinx_monit_conf_dir)}"
            sudo_if_needed "#{fetch(:thinking_sphinx_monit_bin)} reload"
          end
        end
      end
    end

    desc 'Monitor Thinking Sphinx monit-service'
    task :monitor do
      on roles(fetch(:thinking_sphinx_roles)) do
        begin
          sudo_if_needed "#{fetch(:thinking_sphinx_monit_bin)} monitor #{thinking_sphinx_monit_service_name}"
        rescue
          invoke 'thinking_sphinx:monit:config'
          sudo_if_needed "#{fetch(:thinking_sphinx_monit_bin)} monitor #{thinking_sphinx_monit_service_name}"
        end
      end
    end

    desc 'Unmonitor Thinking Sphinx monit-service'
    task :unmonitor do
      on roles(fetch(:thinking_sphinx_roles)) do
        begin
          sudo_if_needed "#{fetch(:thinking_sphinx_monit_bin)} unmonitor #{thinking_sphinx_monit_service_name}"
        rescue
          # no worries here (still no monitoring)
        end
      end
    end

    desc 'Start Thinking Sphinx monit-service'
    task :start do
      on roles(fetch(:thinking_sphinx_roles)) do
        sudo_if_needed "#{fetch(:thinking_sphinx_monit_bin)} start #{thinking_sphinx_monit_service_name}"
      end
    end

    desc 'Stop Thinking Sphinx monit-service'
    task :stop do
      on roles(fetch(:thinking_sphinx_roles)) do
        sudo_if_needed "#{fetch(:thinking_sphinx_monit_bin)}  stop #{thinking_sphinx_monit_service_name}"
      end
    end

    desc 'Restart Thinking Sphinx monit-service'
    task :restart do
      on roles(fetch(:thinking_sphinx_roles)) do
        sudo_if_needed "#{fetch(:thinking_sphinx_monit_bin)} restart #{thinking_sphinx_monit_service_name}"
      end
    end

    before 'deploy:updating', 'thinking_sphinx:monit:unmonitor'
    after 'deploy:published', 'thinking_sphinx:monit:monitor'

    def thinking_sphinx_monit_service_name
      fetch(:thinking_sphinx_monit_service_name, "thinking_sphinx_#{fetch(:application)}_#{fetch(:stage)}")
    end

    def sudo_if_needed(command)
      if fetch(:thinking_sphinx_use_sudo)
        sudo command
      else
        execute command
      end
    end

    def config
      @config ||= ThinkingSphinx::Configuration.instance
    end

    def searchd
      con = config.controller
      "#{con.bin_path}#{con.searchd_binary_name}"
    end

  end
end

def template_crono(from, to)
  [
      "lib/thinking_sphinx/capistrano/templates/#{from}.erb",
      "config/deploy/templates/#{from}.erb",
      File.expand_path("../../templates/#{from}.erb", __FILE__)
  ].each do |path|
    if File.file?(path)
      erb = File.read(path)
      upload! StringIO.new(ERB.new(erb, nil, '-').result(binding)), to
      break
    end
  end
end