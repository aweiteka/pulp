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

Installing the Admin Client

Run the pulp-admin client as a container. Create an alias for the docker run command. The ENTRYPOINT for the container is the pulp-admin executable: pass commands to the alias as arguments. For example: pulp-client "pulp admin arguments".

Setup
1) The ~/.pulp directory is mounted when the container is run. Add the pulp server hostname and any other configuration values to ~/.pulp/admin.conf

    ::[server]
    ::host = pulp-server.example.com
    ::Pull the pulp-admin image
    ::docker pull aweiteka/pulp-admin

2) Create an alias for pulp-client. For example, update your ~/.bashrc file with the line below and run source ~/.bashrc

    ::alias pulp-client=“sudo docker run -t -v /home/<username>/.pulp:/.pulp aweiteka/pulp-admin”

About

    - based on centos image
    - includes pulp beta repository v2.4
    - adds pulp_docker plugin
    See http://www.pulpproject.org/

Dockerfile

Source: https://github.com/aweiteka/pulp/tree/docker_admin_client/client_admin^^^^^^^^^^^^

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

