# More queries

## Querying by criteria

Let's update the query you wrote earlier to allow us to query our actors by first name.

Check the [GraphQL documentation on query variables](https://graphql.org/learn/queries/#variables) so that you have a feel for how to write the query.

Start by writing a query where the condition is *hard-coded*:
```
query actor_query {
  actor(where: {[???]: {_eq: [???]}}) {
    firstname
    lastname
    middlename
    id
  }
}
```

And verify that by changing the hard-coded query value, you can retrieve different records.

Then, apply what you learned from reading the documentation to make the query value variable.

1. Clients *could* just use string concatenation to hard-code the query values into the GraphQL query. Why is it useful to define variables in the query?
2. Looking at the logs, can you see how the query value has been handled as a database parameter. Is it hardcoded into the SQL query string sent to PostgreSQL?

## Querying between entities

Up until now, we haven't really been using the 'graph' part of GraphQL. We have only been retrieving a single type of entity at a time. In this step, we will change that.

Before we can start retrieving data by leveraging the relationships between our entities, we need to [tell Hasura what those relationships are](https://hasura.io/docs/latest/graphql/core/databases/postgres/schema/using-existing-database.html#step-2-track-foreign-keys).

1. Click the "Data" tab in the Hasura console.
2. Click "actor" under "public" under "default" on the left hand side.
3. Click on "Relationships".
4. Add the auto-detected relationship between an Actor and a Role.
5. If you haven't already, insert some actor and role information.
6. Click the "API" tab in the Hasura console.
7. In the "Explorer" note that the "actor" section has additional fields: `roles` and `roles_aggregate`.
8. Add those to the query and then run it.

Notice that one GraphQL query is now retrieving information from multiple tables in your schema.

1. What information did Hasura use to auto-detect the relationship between an actor and a role?
2. Why is there no relationship between the Role and Film detected?
3. Why do you think there is both `roles` and `roles_aggregate`? When do you think you would use each one?

Add another changeset to create the information necessary for Hasura to detect a relationship between a Role and a Film. Then go through the tables in the Hasura console and add all the auto-detected relationships. If you are adding another column to an existing table, it may be simpler to reset your data at this point.

Now, use the "API Explorer" to create a query that traverses our whole graph: actor -> role -> film.

1. Look in the logs to find the queries that are sent to the database. How many queries are executed to retrieve the actor, role and film?
2. How complex can you make the query through the "API Explorer"? Is there a point at which more queries are sent to the database?
