# Cumberbatch

Cumberbatch is a set of helpers for [Cucumber](http://cukes.info/) to support the testing of server configuration inside virtual machine snapshots.

Some of the purpose of this tool was presented at CukeUp 2012 - a video of this 30 minute talk can be found [on the SkillsMatter website](http://skillsmatter.com/podcast/design-architecture/test-driven-infrastructure-cucumber)

*This project is a work in progress*

## Quick start

This distribution contains an example set of [Puppet](http://puppetlabs.com/puppet/puppet-open-source/) manifests, as well as cucumber features to test those manifests.

To try this out, you will need the following prerequisites installed:

 * [Vagrant](http://vagrantup.com/) (and therefore [VirtualBox](http://www.virtualbox.org/))
 * [Sahara](http://rubygems.org/gems/sahara)
 * [Rake](http://rake.rubyforge.org/)
 * [Cucumber](http://cukes.info/)

once you have these installed, run

    rake test

to see the tool in action against an example set of puppet manifests and the standard `lucid32` Vagrant box.

The test run may take several minutes to complete, during which it may appear to be inactive, so be patient.

## How does it work?

The rake script invokes `cucumber`, on every feature file in the `features/` directory, and anywhere under the puppet/ directory.

The step definitions under `features/step_definitions/` use the Cumberbatch support libraries to start, snapshot and interact with Vagrant VMs.  At the end of a scenario, an `After` hook fires, and all modified VMs are rolled back to their initial state, ready to have more tests run against them.

To support more advanced testing, Cumberbatch starts an XML-RPC daemon called `freeman` inside the VM.  This provides a good way to invoke fragments of Ruby inside the VM during testing for easier manipulation of the tested guest.  The features under the `mysql` puppet module are a good example of the use of this approach.

## Next steps

The step definitions all support multi-vm operation, and can be used to build tests against client/server VM pairs.  At present no example of this is provided - VirtualBox is unstable on the Mac when running multiple VMs.


