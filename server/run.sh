#!/bin/bash

case $1 in
  worker)
    exec sudo -u apache /usr/bin/celery worker --events --app=pulp.server.async.app --loglevel=INFO -c 1 -n reserved_resource_worker-1@docker-pulp.cloud.lab.eng.bos.redhat.com --logfile=/var/log/pulp/reserved_resource_worker-1.log --pidfile=/var/run/pulp/reserved_resource_worker-1.pid
    ;;
  beat)
    exec sudo -u apache /usr/bin/celery beat --scheduler=pulp.server.async.scheduler.Scheduler --workdir=/var/lib/pulp/celery/ -f /var/log/pulp/celerybeat.log -l INFO --detach --pidfile=/var/run/pulp/celerybeat.pid
    ;;
  resource_manager)
    exec sudo -u apache /usr/bin/celery worker -c 1 -n resource_manager@localhost --events --app=pulp.server.async.app --loglevel=INFO -Q resource_manager --logfile=/var/log/pulp/resource_manager.log --pidfile=/var/run/pulp/resource_manager.pid
    ;;
  *)
    echo "'$1' is not a supported celery command."
    echo "Use one of the following: worker, beat, resource_manager."
    echo "Exiting"
    exit 1
    ;;
esac
