puppet-openstacklib
================

puppet-openstack helper manifests

This repo contains manifests needed to use the puppet_openstack_builder data model with the aptira scenario.

## Load Balancing

Load balancing is currently done by haproxy, with a VIP maintained by keepalived.

### openstacklib::loadbalance::haproxy

Sets the haproxy defaults and creates public and internal VIPs

### openstacklib::loadbalance::haproxy::%{service_name}

Sets load balancing endpoints for each of the ports used by a particular service on its standard VIP, and for public APIs optionally on the internal VIP as well.

Available services: Ceilometer, Cinder, Dashboard, Glance, Heat, Keystone, MySQL, Neutron, Nova, RabbitMQ.

## Firewall Management

### openstacklib::firewall

Sets dependency order so that firewall rules are applied before any services come up.

### openstacklib::firewall::%{service_name}

Sets firewall rules for each of the ports used by a particular service on its standard interface, and for public APIs, optionally on the internal VIP as well.

Available services: Ceilometer, Cinder, Dashboard, Edeploy, Glance, Heat, Keepalived, Keystone, MySQL, Neutron, Nova, Puppet, RabbitMQ.

## Puppet Master

### openstacklib::puppet::master

Creates a puppet master with puppetdb, passenger and apache.

## Control Hosts Knowledge

### openstacklib::hosts

Creates hosts entries for all control nodes, the build node, and for the fqdn of each node so that the fqdn fact works.

## Repo Management

### openstacklib::repo

Imports repos from the openstack module for cloud packages, and sets yum or apt proxies.

## Version compatibility

### openstacklib::compat

Contains minor fixes that allows puppet modules on version n to deploy version n-1

## Openstack

### openstacklib::openstack::endpoints

Includes the keystone endpoint classes for services in the listed array

### openstacklib::openstack::databases

Includes the database classes for services in the listed array

# Related Modules

This module has taken significant pieces of work and/or inspiration from the following repos:
 - CiscoSystems/puppet-coi
 - CiscoSystems/puppet-coe
 - CiscoSystems/puppet-openstack-ha
 - CiscoSystems/puppet-openstack

# Authors

 - Michael Chapman
