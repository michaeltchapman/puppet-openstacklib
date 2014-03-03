# == Type: keystone_endpoint
#
# Includes the keystone endpoint class
# for the specified service
#
define openstacklib::openstack::keystone_endpoint() {

  include "::${name}::keystone::auth"

}
