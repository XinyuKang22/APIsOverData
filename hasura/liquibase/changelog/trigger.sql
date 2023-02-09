CREATE OR REPLACE FUNCTION on_updated_trigger() RETURNS TRIGGER AS $$
begin
    new.updated_at := now ( );
    new.version := new.version + 1;
    return new;
end
$$ language plpgsql;

CREATE OR REPLACE TRIGGER trigger_on_updated_trigger
    BEFORE UPDATE ON actor
    FOR EACH ROW EXECUTE PROCEDURE on_updated_trigger();