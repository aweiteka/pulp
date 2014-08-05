Pulp Docker Registry Quickstart Guide
=====================================

Pulp 2.4 supports docker content and can serve as a docker registry.

Why Pulp As a Docker Registry?
------------------------------

.. FIXME: links
* Separation of admin (pulp backend client and API) and end-user interface
* Role-based access control (RBAC) with LDAP support
* Enables pushing content to public-facing servers while management interface behind firewall
* Sync content accross an organization
* `Well-documented API <https://pulp-dev-guide.readthedocs.org/en/latest/integration/rest-api/index.html>`_
* `Event-based notifications <https://pulp-dev-guide.readthedocs.org/en/latest/integration/events/index.html>`_ (http/amqp/email) enables CI workflows and viewing history
* Service-oriented architecture (SOA) enables scaling


Components
----------

.. FIXME: make this a table?
* Pulp server (2.4 beta)
* `Pulp admin client <https://registry.hub.docker.com/u/aweiteka/pulp-admin/>`_: remote management client
* `pulp_docker plugin <https://github.com/pulp/pulp_docker>`_ (unreleased): supports docker content type
* `Crane <https://github.com/pulp/crane>`_ (unreleased): partial implementation of the `docker registry protocol <https://docs.docker.com/reference/api/registry_api/>`_
* additional tooling (unreleased): build on Pulp admin client, provides streamlined publishing workflow


Deployment Options
------------------
There are two options for the deployment of Pulp as a Docker Registry:

1. Pulp as a VM, with Crane as a Docker Container
2. A multi-container environment

This document focuses on the multi-container environment.

Installation
------------

Remote Clients
^^^^^^^^^^^^^^

The ``pulp-admin`` client may be `installed as an RPM <installation>`_ or run as a container. To run as a container an alias is created for the ``docker run`` command. The ``ENTRYPOINT`` for the container is the ``pulp-admin`` executable, enabling the user to pass commands to the alias as arguments. For example::

       $ pulp-admin <pulp admin arguments>

The ``pulp-publish-docker`` utility has been developed as a prototype to automate pushing docker images to the Pulp registry. It is based on the pulp-admin client.

Setup

1) The ``~/.pulp directory`` is mounted when the container is run. Add the pulp server hostname and any other configuration values to ``~/.pulp/admin.conf``::

        [server]
        host = pulp-server.example.com

2) Pull the images::

        docker pull aweiteka/pulp-admin
        docker pull aweiteka/pulp-publish-docker

3) Create an alias for pulp-admin. For example, update your ``~/.bashrc`` file with the line below and run ``source ~/.bashrc``::

        alias pulp-admin=“sudo docker run --rm -t -v ~/.pulp:/.pulp -v /tmp/docker_uploads/:/tmp/docker_uploads/ aweiteka/pulp-admin”
        alias publish-docker="sudo docker run --rm -i -t -v ~/.pulp:/.pulp -v /tmp/docker_uploads/:/tmp/docker_uploads/ aweiteka/pulp-publish-docker"

.. note::

   A new container is created each time the pulp-admin runs. The ``--rm`` removes the ephemeral
   container after exiting. This adds a few seconds to execution and is optional.


Server
^^^^^^

The Pulp server is packaged as a multi-container environment. It is an "all-in-one" deployment that requires the containers to run on the same VM or bare metal host.

1) Pull the images::

        IMAGES=( "aweiteka/pulp-apache" "aweiteka/pulp-qpid" )
        for i in "${IMAGES[@]}"; do sudo docker pull $i; done

2) Run the orchestration script::

        ./orchestrate.sh



Pulp Service Structure in Docker with Kubernetes
------------------------------------------------
.. image:: images/Pulp_Service_Structure_in_Docker_with_Kubernetes.png


To Be Done 04 Aug 2014
----------------------
# Outline steps for container deployment. DONE 04 Aug 2014 0009 AEST
# Mention VM as alternate option, referring to upstream docs.
# basic script
# kubernetes (TBA) IMAGE INCLUDED, MORE WORK NEEDED


Publishing Docker Images
------------------------

Usage::

        $ pulp-publish-docker --help
        Usage:
            Upload (2 methods): will create repo if needed, optional publish
              STDIN from "docker save"
              docker save <repo> | ./pulp_docker_util.py --repo <repo> [OPTIONS]

              from previously saved tar file
              ./pulp_docker_util.py --repo <repo> -f </full/path/to/image.tar> [OPTIONS]

            Create repo only (do not upload or publish):
            ./pulp_docker_util.py --repo <repo> [OPTIONS]

            Publish existing repo:
            ./pulp_docker_util.py --repo <repo> --publish

            List repos:
            ./pulp_docker_util.py --list

        Options:
          --version             show program's version number and exit
          -h, --help            show this help message and exit
          -i ID, --id=ID        Pulp repository ID, required for most pulp commands.
                                Only alphanumeric, ., -, and _ allowed
          -r REPO, --repo=REPO  Docker repository name for 'docker pull <my/registry>'.
                                If not specified the Pulp ID will be used
          -d DESCRIPTION, --description=DESCRIPTION
                                Pulp repository description
          -n DISPLAY_NAME, --name=DISPLAY_NAME
                                Pulp repository display name
          -u URL, --url=URL     The URL that will be used when generating the
                                redirect. Defaults to pulp server,
                                https://<pulp_server>/pulp/docker/<repo_id>
          -f FILENAME, --file=FILENAME
                                Full path to image tarball for upload
          -p, --publish         Publish repository. May be added to image upload or
                                used alone.
          -l, --list            List repositories. Used alone.
        $ docker save tianon/true | pulp-publish-docker --id true --repo tianon/true --publish
        Repository [true] successfully created

        +----------------------------------------------------------------------+
                                      Unit Upload
        +----------------------------------------------------------------------+

        Extracting necessary metadata for each request...
        [==================================================] 100%
        Analyzing: test.tar
        ... completed

        Creating upload requests on the server...
        [==================================================] 100%
        Initializing: test.tar
        ... completed

        Starting upload of selected units. If this process is stopped through ctrl+c,
        the uploads will be paused and may be resumed later using the resume command or
        cancelled entirely using the cancel command.

        Uploading: test.tar
        [==================================================] 100%
        18944/18944 bytes
        ... completed

        Importing into the repository...
        This command may be exited via ctrl+c without affecting the request.


        [\]
        Running...

        Task Succeeded


        Deleting the upload request...
        ... completed

        +----------------------------------------------------------------------+
                              Publishing Repository [true]
        +----------------------------------------------------------------------+

        This command may be exited via ctrl+c without affecting the request.


        Publishing Image Files.
        [==================================================] 100%
        3 of 3 items
        ... completed

        Making files available via web.
        [-]
        ... completed


        Task Succeeded



Repository and server management
--------------------------------

The ``pulp-admin`` client is required to manage the pulp server.

Roles
^^^^^

Create roles::

        pulp-admin auth role create --role-id contributors --description "content contributors"
        pulp-admin auth role create --role-id repo_admin --description "Repository management"

Permissions
^^^^^^^^^^^

Permissions may be assigned to roles to control access. See `API documentation <https://pulp-dev-guide.readthedocs.org/en/latest/integration/rest-api/index.html>`_ for paths to resources.

Here we create permissions for the "contributors" role so they can create repositories and upload content but cannot delete repositories::

        pulp-admin auth permission grant --role-id contributors --resource /repositories -o create -o read -o update -o execute
        pulp-admin auth permission grant --role-id repo_admin --resource /repositories -o create -o read -o update -o execute

Users
^^^^^

Users may be manually created. Alternatively the Pulp server may be connected to an LDAP server. See `authentication` for configuration instructions.

Create a contributor user. You will be prompted for a password::

        pulp-admin auth user create --login jdev --name "Joe Developer"
        Enter password for user [jdev] : **********
        Re-enter password for user [jdev]: **********
        User [jdev] successfully created

Create a repository admin user. You will be prompted for a password::

        pulp-admin auth user create --login madmin --name "Mary Admin"

Assign user to role::

        pulp-admin auth role user add --role-id contributors --login jdev
        pulp-admin auth role user add --role-id repo_admin --login madmin


Manage Repositories
^^^^^^^^^^^^^^^^^^^

Groups
++++++

Create repository group::

        pulp-admin repo group create --group-id baseos --description "base OS docker images"

Assign repository to group::

        pulp-admin repo group members add --group-id=baseos --repo-id centos

Metadata
++++++++

Repositories and repository groups may have notes or key:value pair metadata added. Here we add an "environment" note to a repository::

        pulp-admin docker repo update --repo-id centos --note environment=test

Copy
++++

Images may be copied into other repositories for image lifecycle management. Images are not duplicated. Only the metadata references to the images are changed. In other words, copying a repository is an inexpensive operation.

1) Create a new repository::

        pulp-admin docker repo create --repo-id centos-prod --note environment=prod

2) List repository images::

        pulp-admin docker repo images --repo-id centos

3) Copy images into the new repository::

        pulp-admin docker repo copy --from-repo-id centos --to-repo-id centos-prod --match='tag=centos7'


Troubleshooting
---------------

See `Troubleshooting Guide <troubleshooting>`_

Logging
^^^^^^^

From host use journald.

About
^^^^^

* based on centos image
* includes pulp beta repository v2.4
* includes pulp_docker plugin

`Dockerfile Source <https://github.com/aweiteka/pulp-dockerfiles>`_
