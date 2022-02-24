# Building a front end

Now that we have a handle on querying and updating our data, let's expose it via a simple web application.

## React Application

Since we are all reasonably familiar with React, we will start with that.

Use [Create React App](https://create-react-app.dev/docs/adding-typescript/#installation) to create a *Typescript* React application in a new directory. Follow the instructions to test that the application works and that you can make a trivial change before moving onto the next step.

## Apollo Client

Install the [Apollo Client](https://www.apollographql.com/docs/react/get-started/). Edit `index.tsx` and `App.tsx` to bring an instance of the client into scope of the `App` component.

You can find the URL of Hasura's GraphQL Endpoint on the "API" tab.

## Better Typing

Install [Typed Graphqlify](https://github.com/acro5piano/typed-graphqlify) so that we get typing of GraphQL results with less effort.

Edit `App.tsx` to define a simple query to retrieve our actors' id, first name and last name.

```
const getActorsQuery = query('GetActors', {
  [alias('actor', 'actor')]: [{
    id: types.string,
    [???]: types.string,
    [???]: types.string,
  }],
})
```

## Get the data

To make the data available to your `App` component, add a hook inside the `App` component to execute your actor query.

```
const { loading, error, data } = useQuery<typeof getActorsQuery.data>(gql(getActorsQuery.toString()));
```

Verify that `data` is well-typed by using your editor's autocomplete or inspection functions. 

And use it in a very simplistic way:

```
  if (loading) return <p>Loading...</p>;
  if (error) return <p>Error :(</p>;

  console.log(JSON.stringify(data))
```

Check in the browser that your application has been re-loaded and that the console in the browser tools shows your data.

1. What would happen if your `getActorsQuery` does not align with the schema offered by your endpoint? Can you see the details of the error in the client? In the logs of the Hasura container?
2. By default, the `data` returned by `useQuery` has a type of `any`. How have we overridden that? Why do you think it is useful to do that?
3. Use your browser tools to inspect the network request that is sent when the `App` component is rendered. Does it look any different to the request that Postman sends?

## Render the data

Use the knowledge that you already have of React to render a table of actor information.

## Real-time updates

A feature of GraphQL (and supported by Hasura) that we haven't used yet is [Subscriptions](https://hasura.io/docs/latest/graphql/core/databases/postgres/subscriptions/index.html). We can use that functionality to make sure that our table of actor information is always up-to-date.

As always, let's prove that the simplest approach works first. Use Hasura's "API Explorer" to create a new subscription on actors and test that it works. While the subscription is running, use `psql` or some other tool to update the data and validate that you see the results of that update in the "API Explorer".

1. Can you see how the subscription is handled by Hasura?
2. How can you use `psql` to see the queries that are being executed by the database while the subscription is running?

Re-write the `getActors` query to be a subscription instead. Also change `useQuery` to the appropriate method.

1. What error do you see?
2. What is the difference between a `http` and a `ws` URL? What is that part of the URL called?

Follow the necessary steps to [enable websockets for subscriptions only](https://www.apollographql.com/docs/react/data/subscriptions/). The application should now look exactly as it did before.

Test that your subscription is working by updating some actor data and verify that you see the data immediately.

1. What is the difference between the client periodically polling for new data vs a subscription?
2. How would you decide which mechanism to use (hint: see [this guidance from Apollo](https://www.apollographql.com/docs/react/data/subscriptions/#when-to-use-subscriptions))?
3. Does the network request for a subscription look different to one for a query?
