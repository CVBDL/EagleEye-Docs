# EagleEye Cron Job System

It is an independent sub system of EagleEye Platform.

The software utility [Cron](https://en.wikipedia.org/wiki/Cron) is a time-based
job scheduler in Unix-like computer operating systems.

Cron jobs for EagleEye Platform focus on manaing charts and chart sets
automatically.

## How to define a cron job

There're 4 required fields used to define a job.

1. `name`

  It's used to describe the job's name.

2. `expression`

  It's used to set the scheduled time to run this job.
  It's an space seperated string containing 5 ro 6 fields as below:

  ```text
  *    *    *    *    *    *
  ┬    ┬    ┬    ┬    ┬    ┬
  │    │    │    │    │    |
  │    │    │    │    │    └ day of week (0 - 7) (0 or 7 is Sun)
  │    │    │    │    └───── month (1 - 12)
  │    │    │    └────────── day of month (1 - 31)
  │    │    └─────────────── hour (0 - 23)
  │    └──────────────────── minute (0 - 59)
  └───────────────────────── second (0 - 59, OPTIONAL)
  ```

  Some sample definitions:

  | Entry   | Description                                                | expression |
  | ------- | ---------------------------------------------------------- | ---------- |
  | yearly  | Run once a year at midnight of 1 January                   | 0 0 1 1 *  |
  | monthly | Run once a month at midnight of the first day of the month | 0 0 1 * *  |
  | weekly  | Run once a week at midnight on Sunday morning              | 0 0 * * 0  |
  | daily   | Run once a day at midnight                                 | 0 0 * * *  |
  | hourly  | Run once an hour at the beginning of the hour              | 0 * * * *  |

3. `command`

  The command to execute.

4. `enabled`

  Enable or disable the job.

## What happens when a job is to run

Suppose we have a job with the following setttings:

```json
{
  "name": "Code Review By Month",
  "expression": "0 0 * * 0",
  "command": "C:\ccollab2ee.exe",
  "enabled": true
}
```

Then at the midnight on every Sunday, this job will run.

```sh
C:\ccollab2ee.exe --task-id="57837029c66dc1a4570962b6"
```

The command option `--task-id="57837029c66dc1a4570962b6"` is passed by EagleEye
Cron Job System automatically.
