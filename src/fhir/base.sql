CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS pg_trgm; -- for ilike optimisation in search

DROP TABLE IF EXISTS profile CASCADE;
DROP TABLE IF EXISTS searchparameter CASCADE;
DROP TABLE IF EXISTS resource CASCADE;
DROP TABLE IF EXISTS resource_history CASCADE;
DROP TABLE IF EXISTS profile_elements CASCADE;

CREATE TABLE resource (
  version_id text,
  logical_id text,
  resource_type text,
  updated TIMESTAMP WITH TIME ZONE,
  published  TIMESTAMP WITH TIME ZONE,
  category jsonb,
  content jsonb
);

CREATE TABLE resource_history (
  version_id text,
  logical_id text,
  resource_type text,
  updated TIMESTAMP WITH TIME ZONE,
  published  TIMESTAMP WITH TIME ZONE,
  category jsonb,
  content jsonb
);

CREATE TABLE profile (
  base text,
  name text,
  type text,
  kind text,
  installed boolean DEFAULT false
) INHERITS (resource);

ALTER TABLE profile
  ADD PRIMARY KEY (logical_id),
  ALTER COLUMN updated SET NOT NULL,
  ALTER COLUMN updated SET DEFAULT CURRENT_TIMESTAMP,
  ALTER COLUMN published SET NOT NULL,
  ALTER COLUMN published SET DEFAULT CURRENT_TIMESTAMP,
  ALTER COLUMN content SET NOT NULL,
  ALTER COLUMN resource_type SET DEFAULT 'Profile';

CREATE TABLE profile_history () INHERITS (resource_history);
ALTER TABLE profile_history
  ADD PRIMARY KEY (version_id),
  ALTER COLUMN updated SET NOT NULL,
  ALTER COLUMN updated SET DEFAULT CURRENT_TIMESTAMP,
  ALTER COLUMN published SET NOT NULL,
  ALTER COLUMN published SET DEFAULT CURRENT_TIMESTAMP,
  ALTER COLUMN content SET NOT NULL,
  ALTER COLUMN resource_type SET DEFAULT 'Profile';

CREATE TABLE profile_elements (
  profile_id text,
  path text[],
  min text,
  max text,
  type text[],
  formal text,
  comments text,
  isSummary boolean,
  ref_type text[],
  PRIMARY KEY(profile_id, path)
);

CREATE TABLE searchparameter (
  name text,
  base text,
  xpath text,
  path text[],
  search_type text,
  is_primitive boolean,
  type text
) INHERITS (resource);

ALTER TABLE searchparameter
  ADD PRIMARY KEY (logical_id),
  ALTER COLUMN updated SET NOT NULL,
  ALTER COLUMN updated SET DEFAULT CURRENT_TIMESTAMP,
  ALTER COLUMN published SET NOT NULL,
  ALTER COLUMN published SET DEFAULT CURRENT_TIMESTAMP,
  ALTER COLUMN content SET NOT NULL,
  ALTER COLUMN resource_type SET DEFAULT 'SearchParameter';

CREATE TABLE searchparameter_history () INHERITS (resource_history);
ALTER TABLE searchparameter_history
  ADD PRIMARY KEY (version_id),
  ALTER COLUMN updated SET NOT NULL,
  ALTER COLUMN updated SET DEFAULT CURRENT_TIMESTAMP,
  ALTER COLUMN published SET NOT NULL,
  ALTER COLUMN published SET DEFAULT CURRENT_TIMESTAMP,
  ALTER COLUMN content SET NOT NULL,
  ALTER COLUMN resource_type SET DEFAULT 'SearchParameter';
