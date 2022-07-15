# Validation of data

We've already added some basic constraints to our schema by specifying types for columns, flagging mandatory columns "NOT NULL" and adding foreign key relationships.

To perform more sophisticated validation of data, postgres provides two main tools:
1. [check constraints](https://www.postgresql.org/docs/current/ddl-constraints.html#DDL-CONSTRAINTS-CHECK-CONSTRAINTS); and
2. [before triggers](https://www.postgresql.org/docs/current/sql-createtrigger.html).

In this section, we'll use both approaches to add some additional validation and note the differences in how Hasura exposes the results of validation to the caller.

## Check constraint

Create a new changeset that is sourced from an SQL file and add this boilerplate:

```
ALTER TABLE ??? ADD CONSTRAINT actor_name_length_more_than_two CHECK (???);
```

Then fill in the *two* blank sections so that a new constraint is added that checks that actor's first names are more than 2 characters long (hint check the [functions available on strings](https://www.postgresql.org/docs/current/functions-string.html)).

Once the changeset has been applied, check the table definition in the "Data" section of the Hasura console.

1. Where do you see the constraint that you just added?
2. Is there are way to see what the constrained column is and the details of the constraint?

Now, use the "API" section of the console to write a mutation that inserts a new actor. Try inserting an actor with a 'good' and 'bad' first name.

1. What error do you see when you try to insert an actor with a 'bad' last name?

## Before Trigger

Now let's try implementing a similar check but using a trigger instead of a check constraint.

Create a new SQL file changeset and start with:

```
CREATE FUNCTION check_author_name_length()
RETURNS trigger AS $$
DECLARE content_length INTEGER;
BEGIN
  select [???] INTO content_length;

  IF content_length < [???] THEN
      RAISE EXCEPTION 'First name [%] should but at least 5 characters long, but had [%]', NEW.firstname, content_length USING HINT = 'Increase length of first name.';
  END IF;

  -- return the row if no error
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_author_name_length_trigger
  BEFORE INSERT OR UPDATE ON [???]
  FOR EACH ROW
  EXECUTE PROCEDURE [???];
```

Then fill in the *four* blank sections.

Once the changeset has been applied, check the table definition again. 

1. Where do you see the triggers defined?
2. How can you see the function definition? In Hasura console?
3. How can you see the function definition in `psql`?

Use the "API" section to insert an actor with a first name with four characters.

1. What is the difference in the error information produced by the constraint and trigger?
2. Which approach provides more information to the caller?
3. Where is that additional information coming from?

## Cleaning Up

One thing that we forgot to do is add comments to the check constraint, function and trigger.

Create a new change set and add those comments retrospectively.

1. Where do you see those comments in the Hasura console?
2. Where do you see those comments when using `psql`?

## More Reading
(Hasura blog post on the different approaches)[https://hasura.io/docs/latest/graphql/core/databases/postgres/schema/data-validations/]
(Postgres documentation on constraints)[https://www.postgresql.org/docs/current/ddl-constraints.html#DDL-CONSTRAINTS-CHECK-CONSTRAINTS].
