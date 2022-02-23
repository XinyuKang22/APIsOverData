# Handling updates

Okay, time to start making some changes.

1. Get yourself to the "API Explorer". 
2. Find the "Add New" drop down in the bottom left and use it to start building a new `mutation`.
3. Use `insert_actor_one` as the base to insert a new actor, setting the first name, middle name and last name to hard-coded values and returning the id of the inserted row.
4. Update your `mutation` to accept parameters for the first name, middle name and last name.

After you've run the mutation a few times, use `psql` to verify that the data has been inserted into the expected tables.

1. Why don't we need to set the `id` when inserting a new row?