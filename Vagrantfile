# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'vagrant/action/vm/share_folders'
module Vagrant
  module Action
    module VM
      class ShareFolders
        def create_metadata
          @env[:ui].info I18n.t("vagrant.actions.vm.share_folders.creating")

          folders = []
          shared_folders.each do |name, data|
            folders << {
              :name => name,
              :hostpath => File.expand_path(data[:hostpath], @env[:root_path]),
              :transient => data[:transient],
              :readonly => data[:readonly]
            }
          end

          @env[:vm].driver.share_folders(folders)
        end
      end
    end
  end
end

require 'vagrant/driver/virtualbox_4_1'
module Vagrant
  module Driver
    class VirtualBox_4_1
      def share_folders(folders)
        folders.each do |folder|
          args = ["--name",
                  folder[:name],
                  "--hostpath",
                  folder[:hostpath]]
          args << "--transient" if folder.has_key?(:transient) && folder[:transient]
          args << "--readonly" if folder.has_key?(:readonly) && folder[:readonly]
          execute("sharedfolder", "add", @uuid, *args)
        end
      end
    end
  end
end

require 'vagrant/guest/linux'
module Vagrant
  module Guest
    class Linux
      def mount_shared_folder(name, guestpath, options)
        real_guestpath = expanded_guest_path(guestpath)
        @logger.debug("Shell expanded guest path: #{real_guestpath}")
        @vm.channel.sudo("mkdir -p #{real_guestpath}")
        options[:extra] = 'ro' if options[:readonly]
        mount_folder(name, real_guestpath, options)
        @vm.channel.sudo("chown `id -u #{options[:owner]}`:`id -g #{options[:group]}` #{real_guestpath}") unless options[:readonly]
      end
    end
  end
end

Vagrant::Config.run do |config|
  config.vm.define :octopress do |octopress|
    octopress.vm.box = "precise32"
    octopress.vm.host_name = "octopress"

    octopress.vm.forward_port 4000, 4000

    octopress.vm.share_folder "dot-ssh", "/home/vagrant/dot-ssh", "~/.ssh", :readonly => true

    octopress.vm.provision :puppet do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file  = "octopress.pp"
    end
  end
end
