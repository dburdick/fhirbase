-- #import ../gen.sql
-- #import ./metadata.sql

func! generate_tables(_profiles_ text[]) returns text
  --genarate all tables
  SELECT
  count(
  gen._eval(
    gen._tpl($SQL$
      CREATE TABLE "{{tbl_name}}" () INHERITS (resource);

      ALTER TABLE "{{tbl_name}}"
        ADD PRIMARY KEY (logical_id),
        ALTER COLUMN updated SET NOT NULL,
        ALTER COLUMN updated SET DEFAULT CURRENT_TIMESTAMP,
        ALTER COLUMN published SET NOT NULL,
        ALTER COLUMN published SET DEFAULT CURRENT_TIMESTAMP,
        ALTER COLUMN content SET NOT NULL,
        ALTER COLUMN resource_type SET DEFAULT '{{resource_type}}';


      -- this index speedup search joins (cause uuid are casted to texts)
      CREATE UNIQUE INDEX {{tbl_name}}_logical_id_as_text_idx
        ON "{{tbl_name}}" (logical_id);

      CREATE INDEX {{tbl_name}}_full_text_idx
        ON "{{tbl_name}}" USING gin(to_tsvector('english', content::text));

      CREATE TABLE "{{tbl_name}}_history" () INHERITS (resource_history);

      ALTER TABLE "{{tbl_name}}_history"
        ADD PRIMARY KEY (version_id),
        ALTER COLUMN updated SET NOT NULL,
        ALTER COLUMN updated SET DEFAULT CURRENT_TIMESTAMP,
        ALTER COLUMN published SET NOT NULL,
        ALTER COLUMN published SET DEFAULT CURRENT_TIMESTAMP,
        ALTER COLUMN content SET NOT NULL,
        ALTER COLUMN resource_type SET DEFAULT '{{resource_type}}';

     UPDATE profile
       SET installed = true
        WHERE lower(logical_id) = '{{tbl_name}}';
    $SQL$,
    'ns', 'TODO',
    'tbl_name', lower(logical_id),
    'resource_type', logical_id)))::text
  FROM profile
  WHERE kind = 'resource' AND installed = false
    AND (_profiles_ IS NULL OR _profiles_ @> ARRAY[logical_id]);

func! generate_tables() returns text
   SELECT this.generate_tables(null)
