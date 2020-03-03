### About the project

The workspace has 3 projects:

* `AppServices` - A framework responsible to call the API endpoint inside an `Operation`.
* `AppRepository` - A framework to store the hour and queue the operations
* `App` - The target to run the app.

`QTRequestOperation` line 56 has a `sleep` command to simulate delay, so you will be able to check the log message that will not send the same hour again while the operation is running.

