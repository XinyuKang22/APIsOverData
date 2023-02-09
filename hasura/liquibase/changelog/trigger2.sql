CREATE FUNCTION check_author_name_length()
RETURNS trigger AS $$
DECLARE content_length INTEGER;
BEGIN
  select length(NEW.firstname) INTO content_length;
  IF content_length < 5 THEN
      RAISE EXCEPTION 'First name [%] should but at least 5 characters long, but had [%]', NEW.firstname, content_length USING HINT = 'Increase length of first name.';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_author_name_length_trigger
  BEFORE INSERT OR UPDATE ON actor
  FOR EACH ROW
  EXECUTE PROCEDURE check_author_name_length();