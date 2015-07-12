require 'spec_helper'

describe 'neutron::db::sync' do

  shared_examples_for 'neutron-dbsync' do

    it 'runs neutron-db-sync' do
      is_expected.to contain_exec('neutron-db-sync').with(
        :command     => 'neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugin.ini upgrade head',
        :path        => '/usr/bin',
        :refreshonly => 'true',
        :logoutput   => 'on_failure'
      )
    end

  end

  context 'on a RedHat osfamily' do
    let :facts do
      {
        :osfamily                 => 'RedHat',
        :operatingsystemrelease   => '7.0',
        :concat_basedir => '/var/lib/puppet/concat'
      }
    end

    it_configures 'neutron-dbsync'
  end

  context 'on a Debian osfamily' do
    let :facts do
      {
        :operatingsystemrelease => '7.8',
        :operatingsystem        => 'Debian',
        :osfamily               => 'Debian',
        :concat_basedir => '/var/lib/puppet/concat'
      }
    end

    it_configures 'neutron-dbsync'
  end

  context 'with neutron::service_plugins' do
    let :facts do
      {
        :osfamily                 => 'RedHat',
        :operatingsystemrelease   => '7.0',
        :concat_basedir => '/var/lib/puppet/concat'
      }
    end

    let :params do
      {
        :service_plugins => ['router','firewall','lbaas','vpnaas','metering']
      }
    end

    it 'runs neutron-db-sync-lbaas' do
      is_expected.to contain_exec('neutron-db-sync-lbaas').with(
        :command     => 'neutron-db-manage  --service lbaas --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugin.ini upgrade head',
        :path        => '/usr/bin',
        :refreshonly => 'true',
        :logoutput   => 'on_failure'
      )
    end
    it 'runs neutron-db-sync-vpnaas' do
      is_expected.to contain_exec('neutron-db-sync-vpnaas').with(
        :command     => 'neutron-db-manage  --service vpnaas --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugin.ini upgrade head',
        :path        => '/usr/bin',
        :refreshonly => 'true',
        :logoutput   => 'on_failure'
      )
    end
    it 'runs neutron-db-sync-fwaas' do
      is_expected.to contain_exec('neutron-db-sync-fwaas').with(
        :command     => 'neutron-db-manage  --service fwaas --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugin.ini upgrade head',
        :path        => '/usr/bin',
        :refreshonly => 'true',
        :logoutput   => 'on_failure'
      )
    end
  end

end
