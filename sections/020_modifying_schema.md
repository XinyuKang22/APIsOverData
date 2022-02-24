# Modifying your model

Now that you are able to send queries to Hasura and have a fair chance of diagnosing issues, let's extend the model to include more information.

## Edit your database schema

Find the file that holds the database change sets. Read through the [documentation for change sets](https://docs.liquibase.com/concepts/changelogs/xml-format.html) and check that you understand the details of the change set that already exists.

Once you understand the concepts, let's start by adding a new column to an existing table; a 'middle name' for our actors. Create a new change set (make sure it has a new id) and work out how to craft the XML to alter a table and add a new column. For simplicity, make it nullable for now.

Once you've added the XML, save your work and watch tilt apply your changes.

If you take a couple of tries to write the changeset, you might notice that Liquibase stops being able to apply it. Liquibase won't re-apply a changeset it has already applied - even if the content changes. This encourages immutable changesets, but can be annoying when writing a changeset. For now, you can delete the `hasura-postgres` pod to reset your database. Don't worry, we will fix this shortly.

1. How would you manage a change that introduced a new column that was not nullable?

## Figure out how the migration is applied

The liquibase base image is different to the PostgreSQL and Hasura ones. Check the container definitions in `k8s/postgres.yaml` and `k8s/hasura.yaml`. Notice that the image names for hasura-postgres and hasura are using official images. If you wanted, you could find these images on docker hub.

The image for the hasura init container is different, it is using an image that is built by Tilt. This means that whenever the inputs to the image changes, tilt will build the image, push it into the kubernetes cluster's image repository and then reload the container.

1. Find the part of the `Tiltfile` that defines how the Liquibase image is built.
2. Check the log messages that describe the image being rebuilt and the container restarting when the changeset is added.
3. What happens if you break the changeset?
4. What happens if the init container doesn't start correctly?

## Test the changes

Update the query that you have been using to now return the newly added field. Test it out, and validate that the response includes the new fields.

## Contrast with a RESTful approach

1. How would this process have been different if you were following a RESTful approach?
2. Or if you were implementing the API yourself?