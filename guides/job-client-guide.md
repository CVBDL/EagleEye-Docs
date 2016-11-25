# How to write a job client

An *EagleEye Job Client* is an application or a script that could run from
command line.
For example: `ccollab2ee.exe`.

An *EagleEye Job Client* is used to manage charts or chart sets inside
EagleEye Platform.

An *EagleEye Job Client* is desired to be invoked by
[EagleEye Cron Job System](./cron-job-system-guide.md).

## Required command line option

Your job client **MUST** support one command line option `--task-id`.

Whenever your job client is invoked by *EagleEye Cron Job System*,
one specific task id is passing from command line via `--task-id` option.

For example:

```sh
# "ccollab2ee.exe" is an EagleEye Job Client

C:\ccollab2ee.exe --task-id="57837029c66dc1a4570962b6"
```

## Dealing with task id

Whenever a job is to run, *EagleEye Cron Job System* will create a new task to
handle this running attempt.

Right before exiting your job client, you should make a request to notify
EagleEye Platform the state (success, failure, etc.) of the task.

This is the EagleEye Platform API for
[task notification](../rest-api/rest-api.md#edit-task-state).

Request example:

```sh
curl -i -d '{"state":"success"}' http://localhost/api/v1/tasks/57837029c66dc1a4570962b6 -X PUT
```

## Why you have to notify task state

Take the following job client as an example:

```sh
C:\ccollab2ee.exe --task-id="57837029c66dc1a4570962b6"
```

The job client `ccollab2ee.exe` exit with code `0` is not equal to that
the state of task with id `57837029c66dc1a4570962b6` is successful.

When we're checking one task's state, we want to know that if the task
updated some charts successfully.
Rather than the job client exit with code `0` or others.

Sometimes, a job client exiting with code `0` stands for the task is in success
state.
But it depends on implementation.
