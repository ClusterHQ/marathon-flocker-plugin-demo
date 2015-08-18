## marathon-flocker-plugin-demo

A demo of migrating a PHPMyAdmin and MySQL application using Marathon and the Flocker Docker Plugin.

## run

```bash
$ vagrant up
```

Then open `http://172.16.79.250:8080/` in a browser - you will see the Marathon GUI.

Now - we deploy an application:

```bash
$ cat app/demo.json | curl -i -H 'Content-type: application/json' -d @- http://172.16.79.250:8080/v2/groups
```

Then open `http://172.16.79.250:8090/` in a browser - you will see the PHPMyAdmin GUI.

Login with `root:password`

Create a table / insert some data.

Now remove the application:

```bash
$ curl -X DELETE http://172.16.79.250:8080/v2/groups/marathon-demo?force=true
```

Now reschedule the application:

```bash
$ cat app/demo.json | sed 's/spinning/ssd/g' | curl -i -H 'Content-type: application/json' -d @- http://172.16.79.250:8080/v2/groups
```

Then open `http://172.16.79.251:8090/` in a browser - you will see the PHPMyAdmin GUI.

Login with `root:password`

Your data will be there

## build box

To build the box the Vagrantfile is based on:

```
$ make box
```