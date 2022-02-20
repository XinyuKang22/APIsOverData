
# Pre-requisities

1. [Docker](https://docs.docker.com/get-docker/)
2. A kubernetes cluster. You can use the one built into docker.
3. [Tilt](https://docs.tilt.dev/install.html)
4. A tool to make http requests like [httpie](https://httpie.io/), curl or [Postman](https://www.postman.com/downloads/).

# Getting Started

## Familiarise yourself with the components of the solution

The different pieces of the stack are brought together in the `Tiltfile`.

Look in that Tiltfile and find the three major pieces:

1. The Hasura graphql engine.
2. The postgresql database.
3. The migrations that create our model inside the database.

TODO insert diagram here.

Keep in mind that many official (and unofficial images) contain both the containerised application as well as the tools necessary to work with it.

## Start tilt

From the directory containing this README, run `tilt up` to start Tilt. Press `space` to get tilt to open the browser console. If everything is working, you can expect to see that three resources have been successfully processed:

1. The Tiltfile itself.
2. hasura (including the graphql engine and migrations).
3. hasura-postgres (the postgresql database).

## Check that sane things are happening in kubernetes

`kubectl` allows you to watch what is happening in your cluster. Let's watch events in the cluster:

```
kubectl get events --all-namespaces --watch
```

then refresh one of the components in your Tiltfile.

Refresh the `hasura` component and look at the events that are reported.

1. Can you see when the new pod is created? What `kubectl` command can you use to get information about that pod?
2. Can you tell when the liquibase migrations have been applied?

## Expose it to your local environment

Tilt offers a simple way to expose ports into your local environment. Read through the [relevant documentation](https://docs.tilt.dev/accessing_resource_endpoints.html), then add the relevant lines to your Tiltfile to expose both Hasura and Postgres to your local environment.

1. What do you see in the Tilt console after the ports are opened?
2. What other tool can you use to see if the relevant ports have been opened in your local environment? 

Sanity check that the ports are open before moving on.

## Simple Troubleshooting

Before you start extensive trouble-shooting of any issues, it is always a useful to be able to do a simple check of whether a components it working *at all*. This is why - for software we write - we include health checks to provide a high-level view of the status of each important component.

For each of the pieces you've deployed so far, let's confirm whether we can check that the component is available.

### Hasura

Check the [Hasura API specifications](https://hasura.io/docs/latest/graphql/core/api-reference/index.html) to see if there is a simple endpoint that you can hit with `curl`, `httpie` or Postman. 

Once you've found that endpoint, check that it indicates that Hasura is operational:

```
http http://localhost:8080/[???] -v
```

### Postgres

Postgres doesn't offer a simple HTTP endpoint that would allow us to check it is ready to process requests. Instead, we need to execute a query against the database itself.

The cli tool for doing this is `psql`. Assuming that you have it installed, craft a minimal query to check that postgresql is working:

```
psql -U postgres -h localhost -c "[???]"
```

Now, let's check that Liquibase has applied the change set that we expect. Open `hasura/liquibase/changelog/dbchangelog.xml` and determine what tables you expect to have been created.

Use `psql` to query the tables that exist in the database and check that match what is specified in the change set.

1. Where else might `psql` be installed and available?
2. If you didn't want to install `psql` in your local environment, how else could you run it?
3. How can you check that the tables have the right columns?

## Automatically check that the system is working

Kubernetes allows us to [specify different types of container checks](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) to determine whether the container started corrected and is able to accept requests.

To make sure that Hasura is in a fit state to accept requests all the time, let's automate the rough checks that you performed earlier.

### Hasura

Pick the 'type' of liveness probe that you will need to use (http, exec, etc) then add it to the container definition for hasura.

1. How can you validate that the probe is behaving correctly?
2. What happens if you mistype the probe?

### Postgres

Same as above.

1. What does the health end point of hasura report when hasura-postgres is down?
2. Is it a good idea for transitive failures (e.g. Hasura not having access to a working database) to restart the container? To direct traffic away from it?

## Checkpoint - is everything working

Open the Hasura console (you should be able to click on the link in the tilt console) and check that you can map tables.

From the console:

1. Click "Data"
2. Click "public" under "default" on the left hand side.
3. "track" the actor, film and role tables.
4. Insert some rows into the film table.
5. Use the "API" explorer to query the film table by building a query like:
```
query MyQuery {
  film {
    name
    release_date
    id
  }
}
```
6. Validate that you can see the data that you just inserted.
7. Use `psql` to check what data has been inserted into the `film` table.

Now, let's validate that you can call the graphql endpoint from the outside. Use Postman (or your favourite tool) to query an endpoint. You will need to know the URL of the endpoint (hint: you can see this in the "API" explorer of the Hasura console), the HTTP method to use (hint: also visible in the "API" explorer) and how to encapsulate graphql in HTTP.

1. What error message do you get if you use the *wrong* HTTP method?
2. What happens if you request a field that doesn't have a corresponding column in the database?
3. Where can you find the error message from the container for these bad requests?
4. For well-formatted requests, can you see any messages? 
5. Is there a Hasura API that you can query to see which tables have been tracked.

## More logging

To help us debug any queries, let's turn on some more logging in hasura. A common pattern in applications is to give the user an ability to specify what messages get logged under different circumstances by turning on and off entire categories, adjusting logging level of different categories or changing the global log level.

Consulting [the hasura logging documentation](https://hasura.io/docs/latest/graphql/core/deployment/logging.html) re-configure the environment vars in `hasura.yaml` to log the queries that are being sent to the database. As always, notice that tilt takes care of restarting the containers after you save your changes.

Test your changes by re-running your query and verifying that you can see the structure of the query sent to the database.

# Recap

At this point you should be able to:
1. Vheck container logs.
2. Watch events in kubernetes as tilt applies your changes.
3. Check that hasura and postgres are working.
4. Configure hasura to track tables.
5. Insert data into those tables.
6. Query those tables using Postman, `http` or `curl`.
7. Verify that the database query executed by hasura is sane.

If you can't do these things yet, stop and make sure that you can before moving on.

# Modifying your schema

Now that you are able to send queries to hasura and have a fair chance of diagnosing issues.

## Edit your schema

Find the file that holds the database change sets. Read through the [documentation for change sets](https://docs.liquibase.com/concepts/changelogs/xml-format.html) and check that you understand the details of the change set that already exists.

Once you understand the concepts, let's start by adding a new column to an existing table; a 'middle name' for our actors. Create a new change set (make sure it has a new id) and work out how to craft the XML to alter a table and add a new column. For simplicity, make it nullable for now.

Once you've added the XML, save your work and watch tilt apply your changes.

If you take a couple of tries to write the changeset, you might notice that liquibase stops being able to apply it. Liquibase won't re-apply a changeset it has already applied - even if the content changes. This encourages immutable changesets, but can be annoying when writing a changeset. For now, you can delete the `hasura-postgres` pod to reset your database. Don't worry, we will fix this shortly.

1. How would you manage a change that introduced a new column that was not nullable?

## Figure out how the migration is applied

The liquibase base image is different to the postgres and hasura ones. Check the container definitions in `k8s/postgres.yaml` and `k8s/hasura.yaml`. Notice that the image names for hasura-postgres and hasura are using official images. If you wanted, you could find these images on docker hub.

The image for the hasura init container is different, it is using an image that is built by Tilt. This means that whenever the inputs to the image changes, tilt will build the image, push it into the kubernetes cluster's image repository and then reload the container.

1. Find the part of the `Tiltfile` that defines how the image is built.
2. Check the log messages that describe the image being rebuilt and the container restarting when the changeset is added.
3. What happens if you break the changeset?
4. What happens if the init container doesn't start cleanly?

## Test the changes

Update the query that you have been using to now return the newly added field. Test it out, and validate that the response includes the new fields.

## Contrast with a RESTful approach

1. How would this process have been different if you were following a RESTful approach?
2. Or if you were implementing the API yourself?

# Handling updates

# Testing your API

# Integration with a front end

# Authentication and Authorisation

# Asynchronous processes
