### About the project

The workspace has 3 projects:

* `AppServices` - A framework responsible to call the API endpoint inside an `Operation`.
* `AppRepository` - A framework to store the hour and queue the operations
* `App` - The target to run the app.

`RequestOperation` line 58 has a `sleep` command to simulate delay, so you will be able to check the log message that will not send the same hour again while the operation is running.

## What I would change/improve

* Better dependency injection: `SecondsRepository` is creating an instance of `RequestOperation` and it is hard to isolate it to test

* Use `Combine` as a replacement for the closures
