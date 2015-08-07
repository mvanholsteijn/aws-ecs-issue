Amazon ECS does not use the default entrypoint and command line arguments packaged in the container. 
This is really ackward, as most images are ready to run and have sensible default entrypoints and command line parameters.  With ECS I have to reverse engineer the entrypoints and command line arguments to start the container as a task. 

Please fix this and honor the default startup parameters.

## Running a default container from docker
When I create a Docker image using the following Dockerfile

```
FROM ubuntu
ADD doit.sh /
ENTRYPOINT [ "/doit.sh" ]
CMD [ "Hello ECS" ]
```
I can run the image without passing in any parameters.

```
$ docker run mvanholsteijn/ecs-bug
Hello ECS
```

## Running a default container as an ECS Task 
but when I create a default task definition without specifying a entrypoint or arguments, ECS will fail to start the container
```
DockerStateError: [8] System error: exec: "Hello ECS": executable file not found in $PATH
````
it appears that it is trying the execute the cmd instead of the entrypoint plus the cmds.


## files
- Makefile - creates the docker image and pushes it the the registry
- Dockerfile - a sample Dockerfile with default entrypoint and arguments
- runtask.sh - runs a task
- test-noarg.json - ECS task definition running the image without entrypoint or arguments (FAIL)
- test-witharg.json - ECS task definition using arguments only (FAIL)
- test-with-entrypoint-and-args.json  - ECS task definition running with both entrypoint and arguments 

