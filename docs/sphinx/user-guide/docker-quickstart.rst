Pulp Docker Registry Quickstart Guide
=====================================

Pulp 2.4 supports docker content and can serve as a docker registry.

Components
----------

* Pulp server (2.4 beta)
* `Pulp client <https://registry.hub.docker.com/u/aweiteka/pulp-admin/>`_
* `pulp_docker plugin <https://github.com/pulp/pulp_docker>`_ (unreleased)
* `Crane <https://github.com/pulp/crane>`_ (unreleased)
* Storage options: local. Object storage (S3, Google Cloud Storage, Openstack swift) is planned.
* additional tooling (unreleased)


Deployment Options
------------------
There are two options for the deployment of Pulp as a Docker Registry:

1. Pulp as a VM, with Crane as a Docker Container
2. A multi-container environment

This document focuses on the multi-container environment.

Installation
------------

FIXME

Server
^^^^^^

Outline steps for container deployment. Mention VM as alternate option, referring to upstream docs.
* basic script
*  kubernetes (TBA)

Admin client
^^^^^^^^^^^^

Assume container admin client. Mention RPM install option, referring to upstream docs.

Publishing Docker Images
------------------------

* about the utitlity
* work through commands specified in the help file

Repository and server management
--------------------------------

Using the admin client

Roles
^^^^^

Create roles

Permissions
^^^^^^^^^^^

Create permissions

Users
^^^^^

* Create a user
* Assign role

Manage Repositories
^^^^^^^^^^^^^^^^^^^

Groups
++++++

Create repository group

Metadata
++++++++

Assign notes (key:value pairs) to repositories

Copy
++++

Copy repositories for dev-ops type workflows

Troubleshooting
---------------

Logging
^^^^^^^

From host use journald.

.. note::

   test note

.. warning::

   test warning

