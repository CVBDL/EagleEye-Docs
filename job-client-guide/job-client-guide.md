# How to write a job client

An *EagleEye Job Client* is an application or a script that could be ran from
command line. For example: `ccollab2ee.exe`.

An *EagleEye Job Client* is used to manage charts or chart sets inside EagleEye
Platform.

An *EagleEye Job Client* is desired to be invoked by *EagleEye Cron Job System*.

When invoked, One required command line option
`--task-id` (or `-t` for short) will be passed to the
job client.

For example:

```sh
# "ccollab2ee.exe" is an EagleEye Job Client

C:\ccollab2ee.exe --task-id="57837029c66dc1a4570962b6"

# Or invoked this way

C:\ccollab2ee.exe -t "57837029c66dc1a4570962b6"
```

## Dealing with task id

Whenever a job is to run, *EagleEye Cron Job System* will create a task to
handle this running attempt.

Your *EagleEye Job Client* should be able to receive the `--task-id` or `-t` 
command line option.

Right before exit your running job client, you should make a request to notify
EagleEye Platform the state of this task (success or failure).

This is the EagleEye Platform API for
[task notification](../rest-api/rest-api.md#edit-task-state).

For example:

```sh
curl -i -d '{"state":"success"}' http://localhost/api/v1/tasks/57837029c66dc1a4570962b6 -X PUT
```

## Why have to notify task state

Take the following job client as an example:

```sh
C:\ccollab2ee.exe --task-id="57837029c66dc1a4570962b6"
```

The job client `ccollab2ee.exe` exit with code `0` is not equal to that
the state of task `57837029c66dc1a4570962b6` is successful.

When we're checking one task's state, we want to know that if the task
updated some charts successfully.
Rather than the job client exit with code `0` or others.

Sometimes, a job client exiting with code `0` stands for the task is in success
state.
But it depends on implementation.
