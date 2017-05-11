gitlabci-cli 1 "APRIL 2017" gitlabci-cli "User Manuals"
=======================================

NAME
----

gitlabci-cli - Control your GitlabCI workflow from your terminal

SYNOPSIS
--------

`gitlabci-cli` [`COMMAND`] [`-i` *id*] [`-t` *token*] [`-u` *url*]

DESCRIPTION
-----------

`gitlabci-cli` Control your GitlabCI workflow from your terminal

OPTIONS
-------

`-i`, `--id` *id*
  The id of a gitlab project.

`-t`, `--token` *token*
  Your private token.

`-u`, `-url` *url*
  The URL of the gitlab host.

`-p`, `--pipeline` *pipeline*
  The pipeline to get, run, retry or cancel.

OPTIONS
-------

`help` *command*
  Describe available commands or one specific command

`list`
  List the 20 last pipelines for a project

`get`
  Get a pipeline status

`run`
  Run a pipeline for a project

`retry`
  Retry a failed pipeline status

`cancel`
  Cancel a running pipeline status

AUTHOR
------

Wassim DHIF (wassimdhif@gmail.com)
