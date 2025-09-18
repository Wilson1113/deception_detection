--
-- PostgreSQL database dump
--

-- Dumped from database version 15.8
-- Dumped by pg_dump version 15.13 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO supabase_admin;

--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA extensions;


ALTER SCHEMA extensions OWNER TO postgres;

--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql;


ALTER SCHEMA graphql OWNER TO supabase_admin;

--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql_public;


ALTER SCHEMA graphql_public OWNER TO supabase_admin;

--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: pgbouncer
--

CREATE SCHEMA pgbouncer;


ALTER SCHEMA pgbouncer OWNER TO pgbouncer;

--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA realtime;


ALTER SCHEMA realtime OWNER TO supabase_admin;

--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA storage;


ALTER SCHEMA storage OWNER TO supabase_admin;

--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA vault;


ALTER SCHEMA vault OWNER TO supabase_admin;

--
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA graphql;


--
-- Name: EXTENSION pg_graphql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_graphql IS 'pg_graphql: GraphQL support';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: pgjwt; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgjwt WITH SCHEMA extensions;


--
-- Name: EXTENSION pgjwt; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgjwt IS 'JSON Web Token API for Postgresql';


--
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


ALTER TYPE auth.aal_level OWNER TO supabase_auth_admin;

--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


ALTER TYPE auth.code_challenge_method OWNER TO supabase_auth_admin;

--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


ALTER TYPE auth.factor_status OWNER TO supabase_auth_admin;

--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


ALTER TYPE auth.factor_type OWNER TO supabase_auth_admin;

--
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


ALTER TYPE auth.one_time_token_type OWNER TO supabase_auth_admin;

--
-- Name: action; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


ALTER TYPE realtime.action OWNER TO supabase_admin;

--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in'
);


ALTER TYPE realtime.equality_op OWNER TO supabase_admin;

--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


ALTER TYPE realtime.user_defined_filter OWNER TO supabase_admin;

--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


ALTER TYPE realtime.wal_column OWNER TO supabase_admin;

--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


ALTER TYPE realtime.wal_rls OWNER TO supabase_admin;

--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


ALTER FUNCTION auth.email() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


ALTER FUNCTION auth.jwt() OWNER TO supabase_auth_admin;

--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


ALTER FUNCTION auth.role() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


ALTER FUNCTION auth.uid() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_cron_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;

        -- Allow postgres role to allow granting usage on graphql and graphql_public schemas to custom roles
        grant usage on schema graphql_public to postgres with grant option;
        grant usage on schema graphql to postgres with grant option;
    END IF;

END;
$_$;


ALTER FUNCTION extensions.grant_pg_graphql_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;

    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    IF EXISTS (
      SELECT FROM pg_extension
      WHERE extname = 'pg_net'
      -- all versions in use on existing projects as of 2025-02-20
      -- version 0.12.0 onwards don't need these applied
      AND extversion IN ('0.2', '0.6', '0.7', '0.7.1', '0.8', '0.10.0', '0.11.0')
    ) THEN
      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

      REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
      REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

      GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
      GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    END IF;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_net_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_ddl_watch() OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_drop_watch() OWNER TO supabase_admin;

--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


ALTER FUNCTION extensions.set_graphql_placeholder() OWNER TO supabase_admin;

--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: supabase_admin
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
  BEGIN
      RAISE DEBUG 'PgBouncer auth request: %', p_usename;

      RETURN QUERY
      SELECT
          rolname::text,
          CASE WHEN rolvaliduntil < now()
              THEN null
              ELSE rolpassword::text
          END
      FROM pg_authid
      WHERE rolname=$1 and rolcanlogin;
  END;
  $_$;


ALTER FUNCTION pgbouncer.get_auth(p_usename text) OWNER TO supabase_admin;

--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
-- Regclass of the table e.g. public.notes
entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

-- I, U, D, T: insert, update ...
action realtime.action = (
    case wal ->> 'action'
        when 'I' then 'INSERT'
        when 'U' then 'UPDATE'
        when 'D' then 'DELETE'
        else 'ERROR'
    end
);

-- Is row level security enabled for the table
is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

subscriptions realtime.subscription[] = array_agg(subs)
    from
        realtime.subscription subs
    where
        subs.entity = entity_;

-- Subscription vars
roles regrole[] = array_agg(distinct us.claims_role::text)
    from
        unnest(subscriptions) us;

working_role regrole;
claimed_role regrole;
claims jsonb;

subscription_id uuid;
subscription_has_access bool;
visible_to_subscription_ids uuid[] = '{}';

-- structured info for wal's columns
columns realtime.wal_column[];
-- previous identity values for update/delete
old_columns realtime.wal_column[];

error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

-- Primary jsonb output for record
output jsonb;

begin
perform set_config('role', null, true);

columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'columns') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

old_columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'identity') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

for working_role in select * from unnest(roles) loop

    -- Update `is_selectable` for columns and old_columns
    columns =
        array_agg(
            (
                c.name,
                c.type_name,
                c.type_oid,
                c.value,
                c.is_pkey,
                pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
            )::realtime.wal_column
        )
        from
            unnest(columns) c;

    old_columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(old_columns) c;

    if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            -- subscriptions is already filtered by entity
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 400: Bad Request, no primary key']
        )::realtime.wal_rls;

    -- The claims role does not have SELECT permission to the primary key of entity
    elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 401: Unauthorized']
        )::realtime.wal_rls;

    else
        output = jsonb_build_object(
            'schema', wal ->> 'schema',
            'table', wal ->> 'table',
            'type', action,
            'commit_timestamp', to_char(
                ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
            ),
            'columns', (
                select
                    jsonb_agg(
                        jsonb_build_object(
                            'name', pa.attname,
                            'type', pt.typname
                        )
                        order by pa.attnum asc
                    )
                from
                    pg_attribute pa
                    join pg_type pt
                        on pa.atttypid = pt.oid
                where
                    attrelid = entity_
                    and attnum > 0
                    and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
            )
        )
        -- Add "record" key for insert and update
        || case
            when action in ('INSERT', 'UPDATE') then
                jsonb_build_object(
                    'record',
                    (
                        select
                            jsonb_object_agg(
                                -- if unchanged toast, get column name and value from old record
                                coalesce((c).name, (oc).name),
                                case
                                    when (c).name is null then (oc).value
                                    else (c).value
                                end
                            )
                        from
                            unnest(columns) c
                            full outer join unnest(old_columns) oc
                                on (c).name = (oc).name
                        where
                            coalesce((c).is_selectable, (oc).is_selectable)
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                    )
                )
            else '{}'::jsonb
        end
        -- Add "old_record" key for update and delete
        || case
            when action = 'UPDATE' then
                jsonb_build_object(
                        'old_record',
                        (
                            select jsonb_object_agg((c).name, (c).value)
                            from unnest(old_columns) c
                            where
                                (c).is_selectable
                                and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                        )
                    )
            when action = 'DELETE' then
                jsonb_build_object(
                    'old_record',
                    (
                        select jsonb_object_agg((c).name, (c).value)
                        from unnest(old_columns) c
                        where
                            (c).is_selectable
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                    )
                )
            else '{}'::jsonb
        end;

        -- Create the prepared statement
        if is_rls_enabled and action <> 'DELETE' then
            if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                deallocate walrus_rls_stmt;
            end if;
            execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
        end if;

        visible_to_subscription_ids = '{}';

        for subscription_id, claims in (
                select
                    subs.subscription_id,
                    subs.claims
                from
                    unnest(subscriptions) subs
                where
                    subs.entity = entity_
                    and subs.claims_role = working_role
                    and (
                        realtime.is_visible_through_filters(columns, subs.filters)
                        or (
                          action = 'DELETE'
                          and realtime.is_visible_through_filters(old_columns, subs.filters)
                        )
                    )
        ) loop

            if not is_rls_enabled or action = 'DELETE' then
                visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
            else
                -- Check if RLS allows the role to see the record
                perform
                    -- Trim leading and trailing quotes from working_role because set_config
                    -- doesn't recognize the role as valid if they are included
                    set_config('role', trim(both '"' from working_role::text), true),
                    set_config('request.jwt.claims', claims::text, true);

                execute 'execute walrus_rls_stmt' into subscription_has_access;

                if subscription_has_access then
                    visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
                end if;
            end if;
        end loop;

        perform set_config('role', null, true);

        return next (
            output,
            is_rls_enabled,
            visible_to_subscription_ids,
            case
                when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                else '{}'
            end
        )::realtime.wal_rls;

    end if;
end loop;

perform set_config('role', null, true);
end;
$$;


ALTER FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


ALTER FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) OWNER TO supabase_admin;

--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


ALTER FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) OWNER TO supabase_admin;

--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
    declare
      res jsonb;
    begin
      execute format('select to_jsonb(%L::'|| type_::text || ')', val)  into res;
      return res;
    end
    $$;


ALTER FUNCTION realtime."cast"(val text, type_ regtype) OWNER TO supabase_admin;

--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
      /*
      Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
      */
      declare
          op_symbol text = (
              case
                  when op = 'eq' then '='
                  when op = 'neq' then '!='
                  when op = 'lt' then '<'
                  when op = 'lte' then '<='
                  when op = 'gt' then '>'
                  when op = 'gte' then '>='
                  when op = 'in' then '= any'
                  else 'UNKNOWN OP'
              end
          );
          res boolean;
      begin
          execute format(
              'select %L::'|| type_::text || ' ' || op_symbol
              || ' ( %L::'
              || (
                  case
                      when op = 'in' then type_::text || '[]'
                      else type_::text end
              )
              || ')', val_1, val_2) into res;
          return res;
      end;
      $$;


ALTER FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) OWNER TO supabase_admin;

--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
    /*
    Should the record be visible (true) or filtered out (false) after *filters* are applied
    */
        select
            -- Default to allowed when no filters present
            $2 is null -- no filters. this should not happen because subscriptions has a default
            or array_length($2, 1) is null -- array length of an empty array is null
            or bool_and(
                coalesce(
                    realtime.check_equality_op(
                        op:=f.op,
                        type_:=coalesce(
                            col.type_oid::regtype, -- null when wal2json version <= 2.4
                            col.type_name::regtype
                        ),
                        -- cast jsonb to text
                        val_1:=col.value #>> '{}',
                        val_2:=f.value
                    ),
                    false -- if null, filter does not match
                )
            )
        from
            unnest(filters) f
            join unnest(columns) col
                on f.column_name = col.name;
    $_$;


ALTER FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) OWNER TO supabase_admin;

--
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS SETOF realtime.wal_rls
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
      with pub as (
        select
          concat_ws(
            ',',
            case when bool_or(pubinsert) then 'insert' else null end,
            case when bool_or(pubupdate) then 'update' else null end,
            case when bool_or(pubdelete) then 'delete' else null end
          ) as w2j_actions,
          coalesce(
            string_agg(
              realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
              ','
            ) filter (where ppt.tablename is not null and ppt.tablename not like '% %'),
            ''
          ) w2j_add_tables
        from
          pg_publication pp
          left join pg_publication_tables ppt
            on pp.pubname = ppt.pubname
        where
          pp.pubname = publication
        group by
          pp.pubname
        limit 1
      ),
      w2j as (
        select
          x.*, pub.w2j_add_tables
        from
          pub,
          pg_logical_slot_get_changes(
            slot_name, null, max_changes,
            'include-pk', 'true',
            'include-transaction', 'false',
            'include-timestamp', 'true',
            'include-type-oids', 'true',
            'format-version', '2',
            'actions', pub.w2j_actions,
            'add-tables', pub.w2j_add_tables
          ) x
      )
      select
        xyz.wal,
        xyz.is_rls_enabled,
        xyz.subscription_ids,
        xyz.errors
      from
        w2j,
        realtime.apply_rls(
          wal := w2j.data::jsonb,
          max_record_bytes := max_record_bytes
        ) xyz(wal, is_rls_enabled, subscription_ids, errors)
      where
        w2j.w2j_add_tables <> ''
        and xyz.subscription_ids[1] is not null
    $$;


ALTER FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
      select
        (
          select string_agg('' || ch,'')
          from unnest(string_to_array(nsp.nspname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
        )
        || '.'
        || (
          select string_agg('' || ch,'')
          from unnest(string_to_array(pc.relname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
          )
      from
        pg_class pc
        join pg_namespace nsp
          on pc.relnamespace = nsp.oid
      where
        pc.oid = entity
    $$;


ALTER FUNCTION realtime.quote_wal2json(entity regclass) OWNER TO supabase_admin;

--
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  BEGIN
    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    -- Attempt to insert the message
    INSERT INTO realtime.messages (payload, event, topic, private, extension)
    VALUES (payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      -- Capture and notify the error
      PERFORM pg_notify(
          'realtime:system',
          jsonb_build_object(
              'error', SQLERRM,
              'function', 'realtime.send',
              'event', event,
              'topic', topic,
              'private', private
          )::text
      );
  END;
END;
$$;


ALTER FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) OWNER TO supabase_admin;

--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    /*
    Validates that the user defined filters for a subscription:
    - refer to valid columns that the claimed role may access
    - values are coercable to the correct column type
    */
    declare
        col_names text[] = coalesce(
                array_agg(c.column_name order by c.ordinal_position),
                '{}'::text[]
            )
            from
                information_schema.columns c
            where
                format('%I.%I', c.table_schema, c.table_name)::regclass = new.entity
                and pg_catalog.has_column_privilege(
                    (new.claims ->> 'role'),
                    format('%I.%I', c.table_schema, c.table_name)::regclass,
                    c.column_name,
                    'SELECT'
                );
        filter realtime.user_defined_filter;
        col_type regtype;

        in_val jsonb;
    begin
        for filter in select * from unnest(new.filters) loop
            -- Filtered column is valid
            if not filter.column_name = any(col_names) then
                raise exception 'invalid column for filter %', filter.column_name;
            end if;

            -- Type is sanitized and safe for string interpolation
            col_type = (
                select atttypid::regtype
                from pg_catalog.pg_attribute
                where attrelid = new.entity
                      and attname = filter.column_name
            );
            if col_type is null then
                raise exception 'failed to lookup type for column %', filter.column_name;
            end if;

            -- Set maximum number of entries for in filter
            if filter.op = 'in'::realtime.equality_op then
                in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
                if coalesce(jsonb_array_length(in_val), 0) > 100 then
                    raise exception 'too many values for `in` filter. Maximum 100';
                end if;
            else
                -- raises an exception if value is not coercable to type
                perform realtime.cast(filter.value, col_type);
            end if;

        end loop;

        -- Apply consistent order to filters so the unique constraint on
        -- (subscription_id, entity, filters) can't be tricked by a different filter order
        new.filters = coalesce(
            array_agg(f order by f.column_name, f.op, f.value),
            '{}'
        ) from unnest(new.filters) f;

        return new;
    end;
    $$;


ALTER FUNCTION realtime.subscription_check_filters() OWNER TO supabase_admin;

--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


ALTER FUNCTION realtime.to_regrole(role_name text) OWNER TO supabase_admin;

--
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


ALTER FUNCTION realtime.topic() OWNER TO supabase_realtime_admin;

--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


ALTER FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) OWNER TO supabase_storage_admin;

--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
_filename text;
BEGIN
	select string_to_array(name, '/') into _parts;
	select _parts[array_length(_parts,1)] into _filename;
	-- @todo return the last part instead of 2
	return reverse(split_part(reverse(_filename), '.', 1));
END
$$;


ALTER FUNCTION storage.extension(name text) OWNER TO supabase_storage_admin;

--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


ALTER FUNCTION storage.filename(name text) OWNER TO supabase_storage_admin;

--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[1:array_length(_parts,1)-1];
END
$$;


ALTER FUNCTION storage.foldername(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::int) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


ALTER FUNCTION storage.get_size_by_bucket() OWNER TO supabase_storage_admin;

--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


ALTER FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text) OWNER TO supabase_storage_admin;

--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(name COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                        substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1)))
                    ELSE
                        name
                END AS name, id, metadata, updated_at
            FROM
                storage.objects
            WHERE
                bucket_id = $5 AND
                name ILIKE $1 || ''%'' AND
                CASE
                    WHEN $6 != '''' THEN
                    name COLLATE "C" > $6
                ELSE true END
                AND CASE
                    WHEN $4 != '''' THEN
                        CASE
                            WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                                substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                name COLLATE "C" > $4
                            END
                    ELSE
                        true
                END
            ORDER BY
                name COLLATE "C" ASC) as e order by name COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_token, bucket_id, start_after;
END;
$_$;


ALTER FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text) OWNER TO supabase_storage_admin;

--
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


ALTER FUNCTION storage.operation() OWNER TO supabase_storage_admin;

--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
  v_order_by text;
  v_sort_order text;
begin
  case
    when sortcolumn = 'name' then
      v_order_by = 'name';
    when sortcolumn = 'updated_at' then
      v_order_by = 'updated_at';
    when sortcolumn = 'created_at' then
      v_order_by = 'created_at';
    when sortcolumn = 'last_accessed_at' then
      v_order_by = 'last_accessed_at';
    else
      v_order_by = 'name';
  end case;

  case
    when sortorder = 'asc' then
      v_sort_order = 'asc';
    when sortorder = 'desc' then
      v_sort_order = 'desc';
    else
      v_sort_order = 'asc';
  end case;

  v_order_by = v_order_by || ' ' || v_sort_order;

  return query execute
    'with folders as (
       select path_tokens[$1] as folder
       from storage.objects
         where objects.name ilike $2 || $3 || ''%''
           and bucket_id = $4
           and array_length(objects.path_tokens, 1) <> $1
       group by folder
       order by folder ' || v_sort_order || '
     )
     (select folder as "name",
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[$1] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where objects.name ilike $2 || $3 || ''%''
       and bucket_id = $4
       and array_length(objects.path_tokens, 1) = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


ALTER FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


ALTER FUNCTION storage.update_updated_at_column() OWNER TO supabase_storage_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE auth.audit_log_entries OWNER TO supabase_auth_admin;

--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text NOT NULL,
    code_challenge_method auth.code_challenge_method NOT NULL,
    code_challenge text NOT NULL,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone
);


ALTER TABLE auth.flow_state OWNER TO supabase_auth_admin;

--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.flow_state IS 'stores metadata for pkce logins';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE auth.identities OWNER TO supabase_auth_admin;

--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE auth.instances OWNER TO supabase_auth_admin;

--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


ALTER TABLE auth.mfa_amr_claims OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


ALTER TABLE auth.mfa_challenges OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid
);


ALTER TABLE auth.mfa_factors OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


ALTER TABLE auth.one_time_tokens OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


ALTER TABLE auth.refresh_tokens OWNER TO supabase_auth_admin;

--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: supabase_auth_admin
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth.refresh_tokens_id_seq OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: supabase_auth_admin
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


ALTER TABLE auth.saml_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


ALTER TABLE auth.saml_relay_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE auth.schema_migrations OWNER TO supabase_auth_admin;

--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text
);


ALTER TABLE auth.sessions OWNER TO supabase_auth_admin;

--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


ALTER TABLE auth.sso_domains OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


ALTER TABLE auth.sso_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


ALTER TABLE auth.users OWNER TO supabase_auth_admin;

--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: analyzed_subject; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.analyzed_subject (
    id bigint NOT NULL,
    user_id uuid NOT NULL,
    identification_no text NOT NULL,
    name text NOT NULL,
    final_label boolean,
    created_at timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text),
    session_number bigint,
    session_id text,
    ended_at timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text),
    final_prob double precision
);


ALTER TABLE public.analyzed_subject OWNER TO postgres;

--
-- Name: analyzed_subject_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.analyzed_subject ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.analyzed_subject_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: session_video; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.session_video (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    subject_id bigint NOT NULL,
    created_at timestamp without time zone,
    frame_index bigint,
    chunk_url text NOT NULL,
    user_id uuid,
    session_id text
);


ALTER TABLE public.session_video OWNER TO postgres;

--
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    name text NOT NULL,
    improve_model boolean NOT NULL
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- Name: messages; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
)
PARTITION BY RANGE (inserted_at);


ALTER TABLE realtime.messages OWNER TO supabase_realtime_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE realtime.schema_migrations OWNER TO supabase_admin;

--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


ALTER TABLE realtime.subscription OWNER TO supabase_admin;

--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text
);


ALTER TABLE storage.buckets OWNER TO supabase_storage_admin;

--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE storage.migrations OWNER TO supabase_storage_admin;

--
-- Name: objects; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb
);


ALTER TABLE storage.objects OWNER TO supabase_storage_admin;

--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb
);


ALTER TABLE storage.s3_multipart_uploads OWNER TO supabase_storage_admin;

--
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.s3_multipart_uploads_parts OWNER TO supabase_storage_admin;

--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
00000000-0000-0000-0000-000000000000	902c240f-e336-4776-903a-eb865f3b3bdc	{"action":"user_confirmation_requested","actor_id":"45e890a1-9192-4485-bb04-e7271f3d4e98","actor_username":"karyan@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-05-16 14:22:12.974739+00	
00000000-0000-0000-0000-000000000000	08726d8c-0d2d-49d5-82e8-828b924c2606	{"action":"user_confirmation_requested","actor_id":"e786f3b6-4c1b-4bf1-a8e7-ab12902669a3","actor_username":"heekar@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-05-16 14:25:01.272136+00	
00000000-0000-0000-0000-000000000000	f66cdcc2-5a59-4398-a2cf-a64994c0b186	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"karyan@gmail.com","user_id":"45e890a1-9192-4485-bb04-e7271f3d4e98","user_phone":""}}	2025-05-16 14:27:02.231301+00	
00000000-0000-0000-0000-000000000000	9ec7bade-69ad-43dc-a04d-8bd8a8f7413d	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"heekar@gmail.com","user_id":"e786f3b6-4c1b-4bf1-a8e7-ab12902669a3","user_phone":""}}	2025-05-16 14:27:02.238593+00	
00000000-0000-0000-0000-000000000000	cd091954-f169-42a3-a618-a860335b1ed0	{"action":"user_signedup","actor_id":"a0d4a2da-19a6-461c-8846-6a5cda5db4f7","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-05-16 14:35:56.070041+00	
00000000-0000-0000-0000-000000000000	645e6f2f-70cb-4fe6-bd18-42395397febe	{"action":"login","actor_id":"a0d4a2da-19a6-461c-8846-6a5cda5db4f7","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-16 14:35:56.074872+00	
00000000-0000-0000-0000-000000000000	c3563969-495c-44f6-85a2-2572208191c4	{"action":"login","actor_id":"a0d4a2da-19a6-461c-8846-6a5cda5db4f7","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-16 14:36:07.2571+00	
00000000-0000-0000-0000-000000000000	f728117e-3f56-4210-bf34-c3f6165b6c6d	{"action":"login","actor_id":"a0d4a2da-19a6-461c-8846-6a5cda5db4f7","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-16 14:42:06.579433+00	
00000000-0000-0000-0000-000000000000	9de77dbf-e110-4cf0-8e5f-7c5e3f9b53f8	{"action":"logout","actor_id":"a0d4a2da-19a6-461c-8846-6a5cda5db4f7","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-16 14:42:18.363208+00	
00000000-0000-0000-0000-000000000000	6e71e7cd-2510-46b0-8e15-c82a55bc4f37	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"hee.karyan@gmail.com","user_id":"a0d4a2da-19a6-461c-8846-6a5cda5db4f7","user_phone":""}}	2025-05-17 07:43:50.666036+00	
00000000-0000-0000-0000-000000000000	168b20d6-e264-4616-af28-d65017f91714	{"action":"user_signedup","actor_id":"858adb94-a323-4889-8df7-b691858819c8","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-05-17 07:53:12.889246+00	
00000000-0000-0000-0000-000000000000	f53d51c4-f7b0-4049-bd2f-0a89a097cf05	{"action":"login","actor_id":"858adb94-a323-4889-8df7-b691858819c8","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-17 07:53:12.89762+00	
00000000-0000-0000-0000-000000000000	bd16399b-3918-4c36-baa6-9e64cbcbaf06	{"action":"logout","actor_id":"858adb94-a323-4889-8df7-b691858819c8","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-17 08:00:29.698681+00	
00000000-0000-0000-0000-000000000000	4aabcee0-9f1c-4e53-8373-2dd745582e04	{"action":"user_repeated_signup","actor_id":"858adb94-a323-4889-8df7-b691858819c8","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-05-17 08:09:31.591284+00	
00000000-0000-0000-0000-000000000000	e62d10a5-0f33-45f2-b2d9-cd15f4dcb207	{"action":"login","actor_id":"858adb94-a323-4889-8df7-b691858819c8","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-17 08:10:40.599212+00	
00000000-0000-0000-0000-000000000000	00c8078d-0f7d-48f1-baf3-ae2b962b2dc0	{"action":"logout","actor_id":"858adb94-a323-4889-8df7-b691858819c8","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-17 08:13:05.877046+00	
00000000-0000-0000-0000-000000000000	2c594596-f11d-4636-b897-db36593e0474	{"action":"user_recovery_requested","actor_id":"858adb94-a323-4889-8df7-b691858819c8","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-17 09:54:19.741153+00	
00000000-0000-0000-0000-000000000000	f518b815-9279-4abf-8a85-9b80dd948bf4	{"action":"login","actor_id":"858adb94-a323-4889-8df7-b691858819c8","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-17 09:55:09.21053+00	
00000000-0000-0000-0000-000000000000	b434cabf-0dfa-4d71-9987-3c46b3c19484	{"action":"user_updated_password","actor_id":"858adb94-a323-4889-8df7-b691858819c8","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-17 09:55:20.267977+00	
00000000-0000-0000-0000-000000000000	2cc1c38c-ef24-4681-b1ba-63e438f5a94c	{"action":"user_modified","actor_id":"858adb94-a323-4889-8df7-b691858819c8","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-17 09:55:20.26864+00	
00000000-0000-0000-0000-000000000000	976f1ad3-3f82-4805-9eb1-978a44f69b86	{"action":"user_recovery_requested","actor_id":"858adb94-a323-4889-8df7-b691858819c8","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-17 09:56:00.271968+00	
00000000-0000-0000-0000-000000000000	67499ce6-3855-4fc0-aa94-02b5cac4b1e6	{"action":"login","actor_id":"858adb94-a323-4889-8df7-b691858819c8","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-17 09:56:11.228593+00	
00000000-0000-0000-0000-000000000000	04e8ce70-726d-46ec-8cd7-f55c2bdc04f6	{"action":"user_updated_password","actor_id":"858adb94-a323-4889-8df7-b691858819c8","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-17 09:56:21.417873+00	
00000000-0000-0000-0000-000000000000	a8b0d3cb-ffb6-4e69-aabc-5ef9c0b7f9d5	{"action":"user_modified","actor_id":"858adb94-a323-4889-8df7-b691858819c8","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-17 09:56:21.418558+00	
00000000-0000-0000-0000-000000000000	25efd062-4df3-4bf6-b466-38f191c23c1a	{"action":"login","actor_id":"858adb94-a323-4889-8df7-b691858819c8","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-17 09:56:36.256772+00	
00000000-0000-0000-0000-000000000000	ad801b82-c666-40e7-a87e-eb0a199d0e75	{"action":"logout","actor_id":"858adb94-a323-4889-8df7-b691858819c8","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-17 09:56:54.524947+00	
00000000-0000-0000-0000-000000000000	15c8fa18-e431-483f-bc62-85dc3b17d05e	{"action":"login","actor_id":"858adb94-a323-4889-8df7-b691858819c8","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-17 09:57:35.465255+00	
00000000-0000-0000-0000-000000000000	596ce5d9-e853-4217-a1b5-4fe6ae19cea5	{"action":"token_refreshed","actor_id":"858adb94-a323-4889-8df7-b691858819c8","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-18 03:53:09.606197+00	
00000000-0000-0000-0000-000000000000	604d761c-30c1-4789-9e81-449320593e32	{"action":"token_revoked","actor_id":"858adb94-a323-4889-8df7-b691858819c8","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-18 03:53:09.608433+00	
00000000-0000-0000-0000-000000000000	d1e25140-0983-40b1-90b7-81f947e8c366	{"action":"logout","actor_id":"858adb94-a323-4889-8df7-b691858819c8","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-18 04:22:23.42817+00	
00000000-0000-0000-0000-000000000000	929017f5-0154-41df-9fc8-411600f7802f	{"action":"login","actor_id":"858adb94-a323-4889-8df7-b691858819c8","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-18 04:22:32.520438+00	
00000000-0000-0000-0000-000000000000	52ed1538-226c-4273-8bff-ab68ab430538	{"action":"token_refreshed","actor_id":"858adb94-a323-4889-8df7-b691858819c8","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-18 05:22:15.752627+00	
00000000-0000-0000-0000-000000000000	d955d57d-fdc7-43f1-ac7c-8b07d25d7dbe	{"action":"token_revoked","actor_id":"858adb94-a323-4889-8df7-b691858819c8","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-18 05:22:15.754144+00	
00000000-0000-0000-0000-000000000000	90468e2a-c195-4602-abbc-ff0bcab6fc3f	{"action":"login","actor_id":"858adb94-a323-4889-8df7-b691858819c8","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-18 05:26:29.060636+00	
00000000-0000-0000-0000-000000000000	6b4c80a9-faa7-43cb-b5e9-5685a7517a9d	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"hee.karyan@gmail.com","user_id":"858adb94-a323-4889-8df7-b691858819c8","user_phone":""}}	2025-05-18 05:53:18.790578+00	
00000000-0000-0000-0000-000000000000	1dad1535-e8dd-491b-9c77-5b85bf53e9c2	{"action":"user_signedup","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-05-18 05:53:46.782412+00	
00000000-0000-0000-0000-000000000000	a7451e4a-a7a7-4313-8ed7-78c3e432e864	{"action":"login","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-18 05:53:46.788332+00	
00000000-0000-0000-0000-000000000000	dfa3ba0c-16b4-497a-8123-e7cc39e3f4ce	{"action":"logout","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-18 05:54:32.316188+00	
00000000-0000-0000-0000-000000000000	a4d04b2e-717c-43e8-9e2a-786e18d8880f	{"action":"login","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-18 05:54:47.269418+00	
00000000-0000-0000-0000-000000000000	29ebd69d-36c8-4e09-a315-e48a4d55d51b	{"action":"user_modified","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-18 06:22:15.514984+00	
00000000-0000-0000-0000-000000000000	647d59b0-2cf4-4fbc-a396-0c660a76eced	{"action":"user_modified","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan 123","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-18 06:22:22.663832+00	
00000000-0000-0000-0000-000000000000	57bc0868-9ea7-4111-9b61-cc957aadde5f	{"action":"token_refreshed","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan 123","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-18 14:06:54.586553+00	
00000000-0000-0000-0000-000000000000	4bca7f4e-ea25-4bed-b4e7-168277e05790	{"action":"token_revoked","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan 123","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-18 14:06:54.593175+00	
00000000-0000-0000-0000-000000000000	f8f0e81a-4054-4c13-b712-8d8521ae97be	{"action":"token_refreshed","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan 123","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-20 02:30:13.953791+00	
00000000-0000-0000-0000-000000000000	56011991-5ae3-4afe-8157-d8eacb5b979d	{"action":"token_revoked","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan 123","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-20 02:30:13.969871+00	
00000000-0000-0000-0000-000000000000	d19d20fa-cc40-4f0d-ac33-9a074cf98d0e	{"action":"logout","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan 123","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-20 02:30:22.042392+00	
00000000-0000-0000-0000-000000000000	7ec5e6af-36f2-4786-b26e-8f0464e68b4d	{"action":"login","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan 123","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-20 03:26:23.698056+00	
00000000-0000-0000-0000-000000000000	3c1165f5-09bb-4920-a78f-613c14f620ad	{"action":"user_modified","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-20 04:01:46.292856+00	
00000000-0000-0000-0000-000000000000	a0d8729a-ac7f-49ef-a091-b93bad7851cf	{"action":"token_refreshed","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-20 04:36:20.14017+00	
00000000-0000-0000-0000-000000000000	6bec16bb-57b9-4a6a-a843-d9b6e8e21add	{"action":"token_revoked","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-20 04:36:20.143239+00	
00000000-0000-0000-0000-000000000000	296968bc-bf56-493d-ba13-8c93896b21a5	{"action":"user_modified","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-20 04:55:27.197879+00	
00000000-0000-0000-0000-000000000000	ef49a7f3-3665-45e5-a01a-c8869ce90108	{"action":"user_modified","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-20 04:55:30.768452+00	
00000000-0000-0000-0000-000000000000	a2f3026e-5dcd-449b-a52b-a673a4c54cb4	{"action":"user_modified","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-20 04:55:32.35428+00	
00000000-0000-0000-0000-000000000000	1fa34a39-3c93-4570-8def-e445d412e1d5	{"action":"login","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-20 05:06:42.010722+00	
00000000-0000-0000-0000-000000000000	9c53dbb1-8b0f-49f0-ac58-9610957517c7	{"action":"user_updated_password","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-20 05:06:42.280283+00	
00000000-0000-0000-0000-000000000000	2cfa1723-90ad-4f04-8bbf-73bed07d60f1	{"action":"user_modified","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-20 05:06:42.280987+00	
00000000-0000-0000-0000-000000000000	4d6b6d51-e82c-44b9-b102-250cb39465a2	{"action":"logout","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-20 06:00:54.693728+00	
00000000-0000-0000-0000-000000000000	696dca45-e4ad-49be-87aa-2459a402deaa	{"action":"login","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-20 06:01:10.670753+00	
00000000-0000-0000-0000-000000000000	624b9a28-1310-41bb-a3c4-7e383efe1f03	{"action":"login","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-20 06:02:04.141672+00	
00000000-0000-0000-0000-000000000000	954f22b9-ff08-4c0b-837d-89c0d4e8296e	{"action":"user_updated_password","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-20 06:02:04.399857+00	
00000000-0000-0000-0000-000000000000	b09fb5fa-95bd-419c-9ee9-17baf4fd8329	{"action":"user_modified","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-20 06:02:04.401198+00	
00000000-0000-0000-0000-000000000000	cea46f68-d0c5-443f-8fa2-2be1b7cd24f4	{"action":"login","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-20 06:08:44.003425+00	
00000000-0000-0000-0000-000000000000	bdfb80e1-a7e1-42a7-b9dd-c5aa4cda5bbd	{"action":"login","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-20 06:08:50.141736+00	
00000000-0000-0000-0000-000000000000	94df283f-516b-4c47-b854-b2aed07caf8e	{"action":"user_updated_password","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-20 06:08:50.363605+00	
00000000-0000-0000-0000-000000000000	6e9b2f0c-39f2-4706-80df-82412e5dca47	{"action":"user_modified","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-20 06:08:50.364284+00	
00000000-0000-0000-0000-000000000000	006e5b12-636a-4c6a-903b-caf75a6ae3e3	{"action":"login","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-20 06:11:37.814323+00	
00000000-0000-0000-0000-000000000000	333e0fc5-67f8-4f93-a897-59fcae8d66e3	{"action":"user_updated_password","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-20 06:11:38.038519+00	
00000000-0000-0000-0000-000000000000	8e0bdbe9-475d-4ec9-9cda-6804d4cb9544	{"action":"user_modified","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-20 06:11:38.039145+00	
00000000-0000-0000-0000-000000000000	ff7d5db3-33d0-4e93-98a3-e960f2ef99d1	{"action":"user_modified","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-20 06:31:45.81766+00	
00000000-0000-0000-0000-000000000000	7ff126d4-c02b-43e2-8e02-bfb92e5dc492	{"action":"user_modified","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-20 06:31:51.64215+00	
00000000-0000-0000-0000-000000000000	c601a639-c64f-4830-95d5-55d20072b628	{"action":"login","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-20 06:41:28.28982+00	
00000000-0000-0000-0000-000000000000	08787e09-8fb2-401c-ac27-4d75757073f8	{"action":"login","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-20 06:41:34.694428+00	
00000000-0000-0000-0000-000000000000	d3b85b18-835d-4384-bdce-b79f3c2eced1	{"action":"login","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-20 06:59:27.76149+00	
00000000-0000-0000-0000-000000000000	6ed7e59d-e73f-4bbd-b97a-156493c03740	{"action":"login","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-20 07:02:10.469349+00	
00000000-0000-0000-0000-000000000000	e0e45721-916f-4703-a131-dccb3219a474	{"action":"user_updated_password","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-20 07:02:10.716501+00	
00000000-0000-0000-0000-000000000000	2846553d-7d23-45cc-b115-17dd17a19995	{"action":"user_modified","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-20 07:02:10.717201+00	
00000000-0000-0000-0000-000000000000	1404ac7f-2c0e-4a2e-9385-1af95ae4a8cc	{"action":"login","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-20 07:05:34.034955+00	
00000000-0000-0000-0000-000000000000	225d4c29-f0be-4888-82d3-aba480f43319	{"action":"user_updated_password","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-20 07:05:34.265241+00	
00000000-0000-0000-0000-000000000000	e85d9f9b-eda2-43f2-b1a9-a7156150e7a0	{"action":"user_modified","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-20 07:05:34.265921+00	
00000000-0000-0000-0000-000000000000	debe837d-3fff-413c-85a0-9e11b729cef5	{"action":"token_refreshed","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-20 09:49:53.616497+00	
00000000-0000-0000-0000-000000000000	7a18ed3b-b970-4e85-9368-44ff078e743c	{"action":"token_revoked","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-20 09:49:53.621865+00	
00000000-0000-0000-0000-000000000000	589001b4-221c-4fd3-8664-f98b908c2429	{"action":"logout","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-20 09:56:00.293443+00	
00000000-0000-0000-0000-000000000000	a99ea351-9e8f-4798-ab1f-02d3638a7c06	{"action":"login","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-20 10:05:37.275373+00	
00000000-0000-0000-0000-000000000000	250b1bde-c451-4519-b46d-5676b8cafeae	{"action":"token_refreshed","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-21 07:01:30.55173+00	
00000000-0000-0000-0000-000000000000	c0260794-5a12-4cb5-b60e-453f2cfc297e	{"action":"token_revoked","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-21 07:01:30.562429+00	
00000000-0000-0000-0000-000000000000	70466155-eb0d-489e-8542-dab77e15f3ea	{"action":"user_signedup","actor_id":"853416ce-6f41-4333-a136-0dff211dc117","actor_name":"je","actor_username":"jkoh0038@student.monash.edu","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-05-21 07:10:58.04709+00	
00000000-0000-0000-0000-000000000000	2b030a73-fa6a-4472-a58d-7fddc6205133	{"action":"login","actor_id":"853416ce-6f41-4333-a136-0dff211dc117","actor_name":"je","actor_username":"jkoh0038@student.monash.edu","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-21 07:10:58.055817+00	
00000000-0000-0000-0000-000000000000	5aa42c9a-a764-491d-b537-35817458cf40	{"action":"logout","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-21 07:41:31.609664+00	
00000000-0000-0000-0000-000000000000	be865f03-e6e8-4c4c-ae3f-6fbf34358c89	{"action":"token_refreshed","actor_id":"853416ce-6f41-4333-a136-0dff211dc117","actor_name":"je","actor_username":"jkoh0038@student.monash.edu","actor_via_sso":false,"log_type":"token"}	2025-05-21 12:28:05.215053+00	
00000000-0000-0000-0000-000000000000	22c3cef0-dd8e-4743-9203-c1c81684ac19	{"action":"token_revoked","actor_id":"853416ce-6f41-4333-a136-0dff211dc117","actor_name":"je","actor_username":"jkoh0038@student.monash.edu","actor_via_sso":false,"log_type":"token"}	2025-05-21 12:28:05.217928+00	
00000000-0000-0000-0000-000000000000	7e614878-c035-45a1-8ea7-b006a04ad603	{"action":"user_signedup","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-05-21 13:57:30.073841+00	
00000000-0000-0000-0000-000000000000	993bcb94-8c8f-4f36-b4d1-a6084b806bbe	{"action":"login","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-21 13:57:30.084459+00	
00000000-0000-0000-0000-000000000000	d1fc5338-950c-4aca-b1a3-8202b971022b	{"action":"token_refreshed","actor_id":"853416ce-6f41-4333-a136-0dff211dc117","actor_name":"je","actor_username":"jkoh0038@student.monash.edu","actor_via_sso":false,"log_type":"token"}	2025-05-21 14:14:24.489284+00	
00000000-0000-0000-0000-000000000000	800ac8df-59ce-400c-862a-2d6a8449c747	{"action":"token_revoked","actor_id":"853416ce-6f41-4333-a136-0dff211dc117","actor_name":"je","actor_username":"jkoh0038@student.monash.edu","actor_via_sso":false,"log_type":"token"}	2025-05-21 14:14:24.491737+00	
00000000-0000-0000-0000-000000000000	0bf0a181-0257-434c-9223-53b6f5bcf97e	{"action":"token_refreshed","actor_id":"853416ce-6f41-4333-a136-0dff211dc117","actor_name":"je","actor_username":"jkoh0038@student.monash.edu","actor_via_sso":false,"log_type":"token"}	2025-05-21 15:38:48.176871+00	
00000000-0000-0000-0000-000000000000	0a2adb03-3c22-45cd-a209-9f1cfbfa7e2f	{"action":"token_revoked","actor_id":"853416ce-6f41-4333-a136-0dff211dc117","actor_name":"je","actor_username":"jkoh0038@student.monash.edu","actor_via_sso":false,"log_type":"token"}	2025-05-21 15:38:48.180155+00	
00000000-0000-0000-0000-000000000000	da6f4647-f083-4d93-a955-78c66c6b74ec	{"action":"token_refreshed","actor_id":"853416ce-6f41-4333-a136-0dff211dc117","actor_name":"je","actor_username":"jkoh0038@student.monash.edu","actor_via_sso":false,"log_type":"token"}	2025-05-21 17:31:31.341588+00	
00000000-0000-0000-0000-000000000000	72205214-aef9-4529-bb99-3e6d04834e09	{"action":"token_revoked","actor_id":"853416ce-6f41-4333-a136-0dff211dc117","actor_name":"je","actor_username":"jkoh0038@student.monash.edu","actor_via_sso":false,"log_type":"token"}	2025-05-21 17:31:31.346216+00	
00000000-0000-0000-0000-000000000000	f5acccec-737f-41c3-b32b-f4e0a63d17be	{"action":"token_refreshed","actor_id":"853416ce-6f41-4333-a136-0dff211dc117","actor_name":"je","actor_username":"jkoh0038@student.monash.edu","actor_via_sso":false,"log_type":"token"}	2025-05-21 18:32:14.217383+00	
00000000-0000-0000-0000-000000000000	2384a99f-0399-4998-9c58-68e4acd97f81	{"action":"token_revoked","actor_id":"853416ce-6f41-4333-a136-0dff211dc117","actor_name":"je","actor_username":"jkoh0038@student.monash.edu","actor_via_sso":false,"log_type":"token"}	2025-05-21 18:32:14.219637+00	
00000000-0000-0000-0000-000000000000	9efd82af-0186-4283-a1a3-c2efef6c0630	{"action":"token_refreshed","actor_id":"853416ce-6f41-4333-a136-0dff211dc117","actor_name":"je","actor_username":"jkoh0038@student.monash.edu","actor_via_sso":false,"log_type":"token"}	2025-05-21 19:30:59.804343+00	
00000000-0000-0000-0000-000000000000	43ed991d-3780-4b09-bb6e-89a751dc5a83	{"action":"token_revoked","actor_id":"853416ce-6f41-4333-a136-0dff211dc117","actor_name":"je","actor_username":"jkoh0038@student.monash.edu","actor_via_sso":false,"log_type":"token"}	2025-05-21 19:30:59.805727+00	
00000000-0000-0000-0000-000000000000	f3ceae35-6514-4632-b8dc-6d3899a41597	{"action":"token_refreshed","actor_id":"853416ce-6f41-4333-a136-0dff211dc117","actor_name":"je","actor_username":"jkoh0038@student.monash.edu","actor_via_sso":false,"log_type":"token"}	2025-05-21 20:30:45.953313+00	
00000000-0000-0000-0000-000000000000	24cec182-5046-4add-8a32-c51bc7845514	{"action":"token_revoked","actor_id":"853416ce-6f41-4333-a136-0dff211dc117","actor_name":"je","actor_username":"jkoh0038@student.monash.edu","actor_via_sso":false,"log_type":"token"}	2025-05-21 20:30:45.955318+00	
00000000-0000-0000-0000-000000000000	70185b04-104e-45f2-b802-9c190766a078	{"action":"user_modified","actor_id":"853416ce-6f41-4333-a136-0dff211dc117","actor_name":"jekoh","actor_username":"jkoh0038@student.monash.edu","actor_via_sso":false,"log_type":"user"}	2025-05-21 20:47:12.40507+00	
00000000-0000-0000-0000-000000000000	5fdde312-340c-480a-8465-f460971a6edc	{"action":"user_modified","actor_id":"853416ce-6f41-4333-a136-0dff211dc117","actor_name":"je","actor_username":"jkoh0038@student.monash.edu","actor_via_sso":false,"log_type":"user"}	2025-05-21 20:47:22.939466+00	
00000000-0000-0000-0000-000000000000	a2fc2dbe-cf34-48c4-8419-54d06e84b584	{"action":"token_refreshed","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-22 03:17:42.304901+00	
00000000-0000-0000-0000-000000000000	821b28b8-caab-44cc-bab9-adcdd9d586c7	{"action":"token_revoked","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-22 03:17:42.309511+00	
00000000-0000-0000-0000-000000000000	22adff0d-0fd3-4e03-ae40-62cd5877c100	{"action":"token_refreshed","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-22 04:18:13.043691+00	
00000000-0000-0000-0000-000000000000	c55b0caa-28a5-48cd-abef-ff6592899764	{"action":"token_revoked","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-22 04:18:13.046207+00	
00000000-0000-0000-0000-000000000000	7dbe579f-b557-42d1-842d-2ac6aa888103	{"action":"token_refreshed","actor_id":"853416ce-6f41-4333-a136-0dff211dc117","actor_name":"je","actor_username":"jkoh0038@student.monash.edu","actor_via_sso":false,"log_type":"token"}	2025-05-22 04:23:02.579867+00	
00000000-0000-0000-0000-000000000000	5a354e37-9455-4a06-85d8-9b7d92e3e9df	{"action":"token_revoked","actor_id":"853416ce-6f41-4333-a136-0dff211dc117","actor_name":"je","actor_username":"jkoh0038@student.monash.edu","actor_via_sso":false,"log_type":"token"}	2025-05-22 04:23:02.582081+00	
00000000-0000-0000-0000-000000000000	d4eed202-2777-4c30-966b-2bb8e0cdce58	{"action":"token_refreshed","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-22 06:32:33.19558+00	
00000000-0000-0000-0000-000000000000	88684c88-af23-416d-a41e-dbde0a8f120b	{"action":"token_revoked","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-22 06:32:33.207674+00	
00000000-0000-0000-0000-000000000000	a633e4a1-6403-4f1d-bf98-09f386bf70c8	{"action":"logout","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-22 07:09:50.658287+00	
00000000-0000-0000-0000-000000000000	963e2924-bb31-4cd4-bee0-1bf0ae9af069	{"action":"login","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-22 07:10:10.666317+00	
00000000-0000-0000-0000-000000000000	b7613fc8-2c6b-471b-a263-8c36aedbbcd3	{"action":"login","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-22 07:45:27.98718+00	
00000000-0000-0000-0000-000000000000	1ea199c3-4893-4fd7-b74b-08695db6e5a0	{"action":"token_refreshed","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-22 08:24:17.228462+00	
00000000-0000-0000-0000-000000000000	cb56d0d0-9e74-42d9-a3e2-6287061b1723	{"action":"token_revoked","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-22 08:24:17.232196+00	
00000000-0000-0000-0000-000000000000	237c7f06-bcc1-4bce-8510-a398c9589dae	{"action":"token_refreshed","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-22 08:45:15.598779+00	
00000000-0000-0000-0000-000000000000	a249242a-aa81-4818-bb6e-4cbbfc8b3a31	{"action":"token_revoked","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-22 08:45:15.601608+00	
00000000-0000-0000-0000-000000000000	f0ad1e67-d49b-4e0d-a9c4-6f56fd07153f	{"action":"token_refreshed","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-22 09:43:48.430878+00	
00000000-0000-0000-0000-000000000000	c6bbd7da-0496-4268-b60f-54cb9f139aa8	{"action":"token_revoked","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-22 09:43:48.432943+00	
00000000-0000-0000-0000-000000000000	c5163569-d2da-48a3-97f5-be1d787860bb	{"action":"token_refreshed","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-22 12:10:12.560295+00	
00000000-0000-0000-0000-000000000000	9c39d721-ac87-4fa7-9b83-d4363b66a14f	{"action":"token_revoked","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-22 12:10:12.561648+00	
00000000-0000-0000-0000-000000000000	53b4797e-5b2a-4af1-a272-3dbfe2b6208c	{"action":"token_refreshed","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-22 13:10:05.229189+00	
00000000-0000-0000-0000-000000000000	d756dc0e-b079-4de0-bd5c-7693b2d283c9	{"action":"token_revoked","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-22 13:10:05.230665+00	
00000000-0000-0000-0000-000000000000	fa5ca532-d3ee-46e3-a8ea-5c983be34b04	{"action":"token_refreshed","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-22 14:08:34.878279+00	
00000000-0000-0000-0000-000000000000	c97e18ae-c02f-45d3-910c-423aa588e299	{"action":"token_revoked","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-22 14:08:34.882036+00	
00000000-0000-0000-0000-000000000000	24a8833a-bad6-496a-a7f4-15e3bf8c277e	{"action":"login","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-22 14:19:48.680248+00	
00000000-0000-0000-0000-000000000000	6be20b50-1e46-4ee9-aba8-288f121620ca	{"action":"token_refreshed","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-22 15:11:08.795119+00	
00000000-0000-0000-0000-000000000000	1b48795e-11c3-4f2e-a720-033f20952bf6	{"action":"token_revoked","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-22 15:11:08.79778+00	
00000000-0000-0000-0000-000000000000	255c7dde-f312-4be2-bfa4-f9c4dc1e6bdb	{"action":"logout","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-22 15:17:43.417111+00	
00000000-0000-0000-0000-000000000000	7a434ea5-ea00-4f97-94ae-ecd487012a4b	{"action":"token_refreshed","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-22 15:18:36.845243+00	
00000000-0000-0000-0000-000000000000	a46c459b-dc44-4aa7-ac83-9dc55043e799	{"action":"token_revoked","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-22 15:18:36.845838+00	
00000000-0000-0000-0000-000000000000	3c6b90b8-7bf8-4784-978b-baa49fe412b5	{"action":"token_refreshed","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-23 01:38:46.767331+00	
00000000-0000-0000-0000-000000000000	50767809-3879-4b97-840a-e86fb42ffe35	{"action":"token_revoked","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-23 01:38:46.775456+00	
00000000-0000-0000-0000-000000000000	23290c8a-8ed0-4ed7-b693-8de713ca8248	{"action":"token_refreshed","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-23 01:38:55.89502+00	
00000000-0000-0000-0000-000000000000	93b8b163-a3f6-4973-9ac1-bc64e9a5b116	{"action":"token_revoked","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-23 01:38:55.895622+00	
00000000-0000-0000-0000-000000000000	eb256f45-32b7-4f8c-b71d-214c7963b17c	{"action":"token_refreshed","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-23 02:37:30.896934+00	
00000000-0000-0000-0000-000000000000	f885c201-7754-4c4c-a334-99a34eddd60a	{"action":"token_revoked","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-23 02:37:30.90029+00	
00000000-0000-0000-0000-000000000000	65f7ab74-949c-418f-9cc5-6480a8e99ce3	{"action":"token_refreshed","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-23 02:37:38.454661+00	
00000000-0000-0000-0000-000000000000	7447a322-ec60-48b7-bc30-bfb6d620a0f2	{"action":"token_revoked","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-23 02:37:38.455214+00	
00000000-0000-0000-0000-000000000000	7406ef4c-1799-4562-baeb-88236793f2bc	{"action":"logout","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-23 03:09:30.233617+00	
00000000-0000-0000-0000-000000000000	9d77bd19-5943-4b43-a90e-2d175445ee08	{"action":"user_repeated_signup","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-05-23 03:28:21.979732+00	
00000000-0000-0000-0000-000000000000	b86e5e31-1176-454b-8f8e-f15743e6dac7	{"action":"user_repeated_signup","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-05-23 03:31:10.484916+00	
00000000-0000-0000-0000-000000000000	ad7639b2-e268-4213-b6bd-1a3fa09ed22f	{"action":"login","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-23 03:34:27.264957+00	
00000000-0000-0000-0000-000000000000	b2c43f17-dae3-491d-a606-6d7d07e135f3	{"action":"token_refreshed","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-23 04:32:48.81297+00	
00000000-0000-0000-0000-000000000000	a5ff1dd6-a4ff-4ec8-9ac5-10e0a28aad41	{"action":"token_revoked","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-23 04:32:48.814992+00	
00000000-0000-0000-0000-000000000000	8c2ca0f5-2b0e-4e41-95f4-73d5afac18c7	{"action":"logout","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-23 04:40:57.832884+00	
00000000-0000-0000-0000-000000000000	cee28438-6ffc-4090-99a9-f6c154ad6f01	{"action":"user_recovery_requested","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-23 04:41:37.549702+00	
00000000-0000-0000-0000-000000000000	09671bb3-d1aa-4f98-8b94-c4ab678d7dba	{"action":"user_recovery_requested","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-23 04:41:38.733277+00	
00000000-0000-0000-0000-000000000000	a02f3aa7-a286-4883-98bd-d2b51385e8a5	{"action":"login","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-23 04:48:23.656522+00	
00000000-0000-0000-0000-000000000000	49fa38a9-f8b9-4de1-83ae-db832877493e	{"action":"token_refreshed","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-23 08:02:18.119383+00	
00000000-0000-0000-0000-000000000000	8c520e25-8044-418c-b120-0be3a1795541	{"action":"token_revoked","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-23 08:02:18.134182+00	
00000000-0000-0000-0000-000000000000	0da2f3d6-77ec-4f8f-b2ae-50adcd46ed9f	{"action":"login","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-23 09:37:32.45711+00	
00000000-0000-0000-0000-000000000000	1bf1fac8-62ee-4eab-a350-c5f261efe7a6	{"action":"login","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-23 10:27:01.578105+00	
00000000-0000-0000-0000-000000000000	ea0aba35-9c79-45b8-9948-10887d30a96d	{"action":"token_refreshed","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-23 10:35:51.498551+00	
00000000-0000-0000-0000-000000000000	dc8054c5-1b29-45d0-b581-c838ba034afa	{"action":"token_revoked","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-23 10:35:51.502003+00	
00000000-0000-0000-0000-000000000000	55764922-f422-4315-9ec6-4fd33876f84a	{"action":"token_refreshed","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-23 10:39:45.866706+00	
00000000-0000-0000-0000-000000000000	a7aa44ef-32cf-41e1-a1f7-e2749c8b07f7	{"action":"token_revoked","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-23 10:39:45.868734+00	
00000000-0000-0000-0000-000000000000	860ca39e-9348-445f-8f42-999ab2d14cab	{"action":"logout","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-23 10:59:26.034405+00	
00000000-0000-0000-0000-000000000000	d54c2f07-666e-407c-a05f-ffef2b475d3e	{"action":"login","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-23 10:59:48.018708+00	
00000000-0000-0000-0000-000000000000	f3a51ada-e36c-41be-888d-cc66173e82d6	{"action":"logout","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-23 11:00:08.307945+00	
00000000-0000-0000-0000-000000000000	56121268-7802-4850-9a5c-a515ffaf64de	{"action":"login","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-23 11:00:55.912423+00	
00000000-0000-0000-0000-000000000000	f1e94ffb-368e-41d2-9b2e-e995beb7a423	{"action":"token_refreshed","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-23 11:59:16.996856+00	
00000000-0000-0000-0000-000000000000	460c12b0-7ede-42a5-8855-168a1d116a2b	{"action":"token_revoked","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-23 11:59:17.003422+00	
00000000-0000-0000-0000-000000000000	76effb44-df2d-446c-9727-c17c92dc6d18	{"action":"token_refreshed","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-23 12:58:00.251372+00	
00000000-0000-0000-0000-000000000000	c4b4ccf5-e036-4ca9-94db-369cdcdd731e	{"action":"token_revoked","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-23 12:58:00.254229+00	
00000000-0000-0000-0000-000000000000	33b4567f-c411-455d-9342-ddcc52534ad8	{"action":"token_refreshed","actor_id":"853416ce-6f41-4333-a136-0dff211dc117","actor_name":"je","actor_username":"jkoh0038@student.monash.edu","actor_via_sso":false,"log_type":"token"}	2025-05-23 13:04:44.670342+00	
00000000-0000-0000-0000-000000000000	e6a25087-9519-40b7-9e1a-cf7c84c661fa	{"action":"token_revoked","actor_id":"853416ce-6f41-4333-a136-0dff211dc117","actor_name":"je","actor_username":"jkoh0038@student.monash.edu","actor_via_sso":false,"log_type":"token"}	2025-05-23 13:04:44.673157+00	
00000000-0000-0000-0000-000000000000	54499d69-5c7d-46fb-b8ae-249ce3907ba3	{"action":"logout","actor_id":"853416ce-6f41-4333-a136-0dff211dc117","actor_name":"je","actor_username":"jkoh0038@student.monash.edu","actor_via_sso":false,"log_type":"account"}	2025-05-23 13:04:53.347526+00	
00000000-0000-0000-0000-000000000000	ec33150b-2fc1-48b6-9f1d-f28a2d7bc3ec	{"action":"user_signedup","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-05-23 13:05:17.926713+00	
00000000-0000-0000-0000-000000000000	5aa9b531-911b-4e8f-96f3-b6fd32238597	{"action":"login","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-23 13:05:17.931752+00	
00000000-0000-0000-0000-000000000000	47ea3b8f-8fba-4a72-ae22-4caac7ed5a1d	{"action":"logout","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-23 13:27:10.87476+00	
00000000-0000-0000-0000-000000000000	74331c40-a00a-471c-8447-824c72f0395e	{"action":"login","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-23 13:31:49.831073+00	
00000000-0000-0000-0000-000000000000	69aaf6a3-2d9f-4c54-b706-be1e5595cbba	{"action":"token_refreshed","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-23 14:04:56.748793+00	
00000000-0000-0000-0000-000000000000	c80f0ba7-3e88-4dbe-b4be-4fe68753777c	{"action":"token_revoked","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-23 14:04:56.751514+00	
00000000-0000-0000-0000-000000000000	2a4deef0-56c8-46b5-b741-ce3e5022ceb0	{"action":"token_refreshed","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-23 14:18:32.021861+00	
00000000-0000-0000-0000-000000000000	015c6cca-b7b1-4a28-bf43-1868e32ea32b	{"action":"token_revoked","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-23 14:18:32.02381+00	
00000000-0000-0000-0000-000000000000	6129bc99-63ce-4950-877f-dae592b5f078	{"action":"logout","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-23 14:18:40.174785+00	
00000000-0000-0000-0000-000000000000	e585b065-e88b-41f0-b78a-60c0f27fb7e0	{"action":"user_recovery_requested","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-23 14:23:57.640806+00	
00000000-0000-0000-0000-000000000000	eaefb0a3-fa3b-43c6-827b-9ef5bb1dfd13	{"action":"user_recovery_requested","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-23 14:23:58.300374+00	
00000000-0000-0000-0000-000000000000	6202164f-fef8-41d0-9c94-a0c01752b8c3	{"action":"login","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-23 14:24:21.148005+00	
00000000-0000-0000-0000-000000000000	1ff1777b-dad9-408f-849c-1f8d9e037fd5	{"action":"token_refreshed","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-23 14:29:56.556226+00	
00000000-0000-0000-0000-000000000000	19c72d1c-65e4-4a72-8676-97bac80823e1	{"action":"token_revoked","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-23 14:29:56.557452+00	
00000000-0000-0000-0000-000000000000	16cb7ce2-90a4-416f-9aab-420635596bdb	{"action":"token_refreshed","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-23 15:03:52.122592+00	
00000000-0000-0000-0000-000000000000	5a2cbfa7-7e67-4e11-a2b6-608e33ab93a3	{"action":"token_revoked","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-23 15:03:52.124523+00	
00000000-0000-0000-0000-000000000000	ba1c0656-2033-4868-9214-aaaab4649751	{"action":"token_refreshed","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-23 15:29:07.740334+00	
00000000-0000-0000-0000-000000000000	5aebb303-e61f-444f-80bf-bf36b772fd56	{"action":"token_revoked","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-23 15:29:07.74185+00	
00000000-0000-0000-0000-000000000000	4fb5979b-d6c0-4d4f-917a-e6a01b7b4d0d	{"action":"token_refreshed","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-24 00:41:26.14906+00	
00000000-0000-0000-0000-000000000000	9e69d6a3-b2c5-4ac7-accc-591844bf1df1	{"action":"token_revoked","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-24 00:41:26.168602+00	
00000000-0000-0000-0000-000000000000	a0f75cde-6c90-43c2-aa80-2d2392c0a242	{"action":"token_refreshed","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-24 02:50:18.71908+00	
00000000-0000-0000-0000-000000000000	09ea2cd0-39fe-4833-96ec-f27197ec34e1	{"action":"token_revoked","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-24 02:50:18.722054+00	
00000000-0000-0000-0000-000000000000	a7b30b69-ecc2-42f3-8820-9101e475137e	{"action":"token_refreshed","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-24 12:24:39.643453+00	
00000000-0000-0000-0000-000000000000	692c7612-e415-4fb1-8ee1-14662268fb8e	{"action":"token_revoked","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-24 12:24:39.657593+00	
00000000-0000-0000-0000-000000000000	92383cc6-e54e-4ba1-804e-5460839c147e	{"action":"logout","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-24 12:28:36.32866+00	
00000000-0000-0000-0000-000000000000	8ad0edea-ea58-4df2-9483-7b65a40ac972	{"action":"login","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-24 12:28:43.753208+00	
00000000-0000-0000-0000-000000000000	1ce02c5a-f4a0-44f1-b7c4-aa69e446e2cd	{"action":"logout","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-24 12:33:56.892135+00	
00000000-0000-0000-0000-000000000000	8a496bb1-c766-4951-b34b-97e0950a06f3	{"action":"login","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-24 12:34:04.959014+00	
00000000-0000-0000-0000-000000000000	0db2373c-a225-48a3-a832-19bed386ff88	{"action":"token_refreshed","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-24 13:33:50.052311+00	
00000000-0000-0000-0000-000000000000	c47b217b-5b88-4a51-9f40-2f507e361429	{"action":"token_revoked","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-24 13:33:50.055353+00	
00000000-0000-0000-0000-000000000000	e36e61dc-c16b-40c4-bca1-e52823fecf30	{"action":"token_refreshed","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-26 06:52:02.580391+00	
00000000-0000-0000-0000-000000000000	8bfa456c-74bc-47c4-993a-f845eb0a2569	{"action":"token_revoked","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-26 06:52:02.595129+00	
00000000-0000-0000-0000-000000000000	e1bbd61c-396f-4c89-a92e-f8d8f960fae7	{"action":"logout","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-26 06:53:15.484514+00	
00000000-0000-0000-0000-000000000000	7bb15831-92d5-4c57-8dd1-e8745601f650	{"action":"login","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-26 06:54:07.944973+00	
00000000-0000-0000-0000-000000000000	48200a3f-51ed-4fd4-ab57-ccfe6d054165	{"action":"user_signedup","actor_id":"be560e00-5f19-49d7-b245-76852457e398","actor_name":"Chong Chi Yang","actor_username":"ccho0092@student.monash.edu","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-05-26 14:06:21.254075+00	
00000000-0000-0000-0000-000000000000	90947fb7-d06b-487f-80c7-0b95bf074d48	{"action":"login","actor_id":"be560e00-5f19-49d7-b245-76852457e398","actor_name":"Chong Chi Yang","actor_username":"ccho0092@student.monash.edu","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-26 14:06:21.265322+00	
00000000-0000-0000-0000-000000000000	51d3cb2e-368e-4314-9382-0193be4e1acd	{"action":"token_refreshed","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 02:30:21.73337+00	
00000000-0000-0000-0000-000000000000	9169223b-f0fd-4b86-9632-011abf29949b	{"action":"token_revoked","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 02:30:21.745035+00	
00000000-0000-0000-0000-000000000000	84094af1-6cd6-4e1d-ad1e-feb797c7eac2	{"action":"token_refreshed","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 03:49:29.28363+00	
00000000-0000-0000-0000-000000000000	e0242fa2-5e6b-48e7-9977-23d417dd9686	{"action":"token_revoked","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 03:49:29.290025+00	
00000000-0000-0000-0000-000000000000	732241f3-a1e6-46e8-8447-55c1aecf1ac2	{"action":"login","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-27 04:55:47.403049+00	
00000000-0000-0000-0000-000000000000	3d00f05a-4f92-4013-b40a-b52d48584a2a	{"action":"token_refreshed","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 05:02:53.991523+00	
00000000-0000-0000-0000-000000000000	a81f6e14-c687-4c92-9ae2-6cafbed9772a	{"action":"token_revoked","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 05:02:53.993041+00	
00000000-0000-0000-0000-000000000000	ef11f447-b02d-48c4-91da-c330952fbf7f	{"action":"token_refreshed","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 05:06:33.395436+00	
00000000-0000-0000-0000-000000000000	8b865a53-6d86-4466-8297-356421ccac51	{"action":"token_revoked","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 05:06:33.396272+00	
00000000-0000-0000-0000-000000000000	4727373a-d245-4af3-8f8a-4dc1bf1c6feb	{"action":"logout","actor_id":"909f7829-6617-4bb8-a5be-6936edef5a48","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-27 05:19:52.582513+00	
00000000-0000-0000-0000-000000000000	3c19be6b-a6ec-4871-a77e-ed0ae45203d8	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"wilsonteoshiyang@gmail.com","user_id":"909f7829-6617-4bb8-a5be-6936edef5a48","user_phone":""}}	2025-05-27 05:20:01.023617+00	
00000000-0000-0000-0000-000000000000	02eeffe9-b6d2-485b-931e-1efd073f2cae	{"action":"user_signedup","actor_id":"fb6b83d8-1528-440a-851a-2ef159b28b65","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-05-27 05:20:12.72671+00	
00000000-0000-0000-0000-000000000000	694263a2-ded2-4aa4-afdb-55199e1b0ad4	{"action":"login","actor_id":"fb6b83d8-1528-440a-851a-2ef159b28b65","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-27 05:20:12.732628+00	
00000000-0000-0000-0000-000000000000	63d14d9e-d95a-4622-97be-7e0555607e08	{"action":"token_refreshed","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 06:04:54.015213+00	
00000000-0000-0000-0000-000000000000	f6a15e5b-90c4-4be1-b6df-fe7d7fb2c72b	{"action":"token_revoked","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 06:04:54.021146+00	
00000000-0000-0000-0000-000000000000	a73987df-4d24-4f05-a4d7-b32754d4e6e4	{"action":"token_refreshed","actor_id":"fb6b83d8-1528-440a-851a-2ef159b28b65","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 06:18:32.407601+00	
00000000-0000-0000-0000-000000000000	5519fe65-7c15-47a5-921e-8b20e7ae0944	{"action":"token_revoked","actor_id":"fb6b83d8-1528-440a-851a-2ef159b28b65","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 06:18:32.410873+00	
00000000-0000-0000-0000-000000000000	d27e0ac1-d690-4ae2-a180-27d08a042b45	{"action":"token_refreshed","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 07:06:42.588136+00	
00000000-0000-0000-0000-000000000000	e1189370-d512-43cb-94f2-49410e7d40a5	{"action":"token_revoked","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 07:06:42.594308+00	
00000000-0000-0000-0000-000000000000	6291a083-7dec-4852-85d9-dc8a1efda535	{"action":"token_refreshed","actor_id":"fb6b83d8-1528-440a-851a-2ef159b28b65","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 07:32:57.06721+00	
00000000-0000-0000-0000-000000000000	3fd0080d-b328-44c6-bcd6-6819a4802ec7	{"action":"token_revoked","actor_id":"fb6b83d8-1528-440a-851a-2ef159b28b65","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 07:32:57.070677+00	
00000000-0000-0000-0000-000000000000	58ed35d1-e5b6-4be4-8425-ee90a1547597	{"action":"token_refreshed","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 08:05:33.354021+00	
00000000-0000-0000-0000-000000000000	2a5cacd3-9497-47d7-8510-04ca3e3c9814	{"action":"token_revoked","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 08:05:33.356585+00	
00000000-0000-0000-0000-000000000000	1807b351-656a-4758-8237-1da22856d091	{"action":"token_refreshed","actor_id":"fb6b83d8-1528-440a-851a-2ef159b28b65","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 08:31:55.062187+00	
00000000-0000-0000-0000-000000000000	e852e82f-2299-4126-8420-ab0f380aa1b2	{"action":"token_revoked","actor_id":"fb6b83d8-1528-440a-851a-2ef159b28b65","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 08:31:55.063698+00	
00000000-0000-0000-0000-000000000000	1d981e8c-6e2d-4132-8323-f6772ac76086	{"action":"token_refreshed","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 08:47:47.203636+00	
00000000-0000-0000-0000-000000000000	5fa33e33-99ac-4923-a891-1af5cefba61a	{"action":"token_revoked","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 08:47:47.205158+00	
00000000-0000-0000-0000-000000000000	bda98add-9cc4-4e21-84e6-5efe08a1898b	{"action":"logout","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-27 08:55:19.376311+00	
00000000-0000-0000-0000-000000000000	7aaf0b3b-ae15-4d99-bbd7-d2f667860301	{"action":"token_refreshed","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 09:04:03.866995+00	
00000000-0000-0000-0000-000000000000	6994bf6e-232d-4a14-9307-429364e33c7b	{"action":"token_revoked","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 09:04:03.869586+00	
00000000-0000-0000-0000-000000000000	a6aa2fcf-1d96-41e3-b043-c821b2c60363	{"action":"token_refreshed","actor_id":"fb6b83d8-1528-440a-851a-2ef159b28b65","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 09:30:01.790302+00	
00000000-0000-0000-0000-000000000000	c3919359-70f8-4ed6-8e82-5132c1cf4069	{"action":"token_revoked","actor_id":"fb6b83d8-1528-440a-851a-2ef159b28b65","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 09:30:01.793141+00	
00000000-0000-0000-0000-000000000000	381199e6-e71d-45f6-99e4-b7f65b8d06d5	{"action":"token_refreshed","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 10:03:01.57173+00	
00000000-0000-0000-0000-000000000000	8eda491c-b93d-4170-bc86-07428b0ca5af	{"action":"token_revoked","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 10:03:01.57471+00	
00000000-0000-0000-0000-000000000000	120ff760-9599-41b4-a0ca-94c66fc37b1c	{"action":"logout","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-27 10:21:26.685506+00	
00000000-0000-0000-0000-000000000000	0a38d193-1ace-4b2b-909a-07d6559f2daa	{"action":"login","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-27 10:21:41.676377+00	
00000000-0000-0000-0000-000000000000	1c5a1b9d-2f2d-4ba7-ab93-907d04dbef54	{"action":"token_refreshed","actor_id":"fb6b83d8-1528-440a-851a-2ef159b28b65","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 10:28:57.617331+00	
00000000-0000-0000-0000-000000000000	bf105387-a2af-44f5-930b-69931a78113a	{"action":"token_revoked","actor_id":"fb6b83d8-1528-440a-851a-2ef159b28b65","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 10:28:57.618776+00	
00000000-0000-0000-0000-000000000000	dcf7af25-201f-4727-9d93-a04dd4d59c0e	{"action":"login","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-27 10:34:45.400708+00	
00000000-0000-0000-0000-000000000000	210cf5f3-4ffd-422f-bfcd-3e38ffc798f6	{"action":"token_refreshed","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 11:39:30.0405+00	
00000000-0000-0000-0000-000000000000	80408f9b-72f2-4132-ae6a-7845556d9fda	{"action":"token_revoked","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 11:39:30.05246+00	
00000000-0000-0000-0000-000000000000	fb40f8d8-a974-4597-9594-0bba210638fc	{"action":"token_refreshed","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 11:47:22.921821+00	
00000000-0000-0000-0000-000000000000	56e28b5a-3093-4a14-8a33-67f3cf4c571b	{"action":"token_revoked","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 11:47:22.925533+00	
00000000-0000-0000-0000-000000000000	6ff4f45a-f873-430a-b87e-97a6365f8b78	{"action":"token_refreshed","actor_id":"fb6b83d8-1528-440a-851a-2ef159b28b65","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 11:49:44.604706+00	
00000000-0000-0000-0000-000000000000	23db3c02-a828-44ba-82d1-43b473a6da7c	{"action":"token_revoked","actor_id":"fb6b83d8-1528-440a-851a-2ef159b28b65","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 11:49:44.607158+00	
00000000-0000-0000-0000-000000000000	8c3ff558-277d-4b13-b2a6-cc0aa1f2046b	{"action":"logout","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-27 12:15:31.034946+00	
00000000-0000-0000-0000-000000000000	8cbe96a5-15ea-499e-8135-4c0cfcd26668	{"action":"login","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-27 12:15:51.760529+00	
00000000-0000-0000-0000-000000000000	60dcc215-5704-48fe-9157-989a0e00ab54	{"action":"logout","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-27 12:15:54.151269+00	
00000000-0000-0000-0000-000000000000	dc6c3cfd-2e93-4e36-83ef-b2d95079f9ea	{"action":"login","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-27 12:16:24.562143+00	
00000000-0000-0000-0000-000000000000	3390c8ef-4733-4d1d-b5d1-cf0c351992fb	{"action":"logout","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-27 12:23:23.827017+00	
00000000-0000-0000-0000-000000000000	b9fb2a61-fcf7-4706-85f2-f09e26e6dbc2	{"action":"user_recovery_requested","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-27 12:23:30.843239+00	
00000000-0000-0000-0000-000000000000	5dac4a13-fa24-4e10-a397-1680404ee439	{"action":"user_recovery_requested","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-27 12:23:31.995049+00	
00000000-0000-0000-0000-000000000000	8e602c46-8a8f-40a4-a082-6547e8c7b37a	{"action":"user_repeated_signup","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-05-27 12:24:41.25472+00	
00000000-0000-0000-0000-000000000000	87805fda-49c3-4c49-bfc7-29422a763364	{"action":"user_repeated_signup","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-05-27 12:26:52.868283+00	
00000000-0000-0000-0000-000000000000	6ebb4d6f-13a0-469f-aac1-27e8ea88526a	{"action":"login","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-27 12:34:25.047685+00	
00000000-0000-0000-0000-000000000000	e6d38421-7000-44a3-ac68-575d0bfef13e	{"action":"login","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-28 03:18:43.261257+00	
00000000-0000-0000-0000-000000000000	fc60b064-3a0a-41e6-8b38-ebac02f25be0	{"action":"token_refreshed","actor_id":"fb6b83d8-1528-440a-851a-2ef159b28b65","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 12:48:40.837677+00	
00000000-0000-0000-0000-000000000000	b155106b-e789-4d14-8c9a-8913a08bda84	{"action":"token_revoked","actor_id":"fb6b83d8-1528-440a-851a-2ef159b28b65","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 12:48:40.841637+00	
00000000-0000-0000-0000-000000000000	7b2d1295-0680-4dd5-82e5-4a0154253996	{"action":"token_refreshed","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 12:56:35.386365+00	
00000000-0000-0000-0000-000000000000	e2f604d4-2f60-410f-b0db-53ccc3e23b07	{"action":"token_revoked","actor_id":"c1624ddd-be2e-46b1-b166-572f3c222a06","actor_name":"kar yan","actor_username":"hee.karyan@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 12:56:35.39244+00	
00000000-0000-0000-0000-000000000000	5ce877b3-66ab-4645-87b9-35c998ca4b33	{"action":"token_refreshed","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 13:33:10.638286+00	
00000000-0000-0000-0000-000000000000	542e44dd-d1ff-43b0-920e-acac648e35f3	{"action":"token_revoked","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 13:33:10.642216+00	
00000000-0000-0000-0000-000000000000	da222bef-c67f-4d5b-b2ce-eadcec683424	{"action":"token_refreshed","actor_id":"fb6b83d8-1528-440a-851a-2ef159b28b65","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 13:46:45.883515+00	
00000000-0000-0000-0000-000000000000	98f1e32f-89cf-42bf-9df9-45e764ff4094	{"action":"token_revoked","actor_id":"fb6b83d8-1528-440a-851a-2ef159b28b65","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 13:46:45.885941+00	
00000000-0000-0000-0000-000000000000	13eff790-59b0-4d68-afcf-bf58130ada83	{"action":"logout","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-27 14:21:50.612411+00	
00000000-0000-0000-0000-000000000000	eb89b1d9-cf4c-4951-a6df-6bcfdd3c54ad	{"action":"user_recovery_requested","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-27 14:22:32.831597+00	
00000000-0000-0000-0000-000000000000	275b6698-1023-4620-97ae-7aaa7ea51530	{"action":"user_repeated_signup","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-05-27 14:23:58.375628+00	
00000000-0000-0000-0000-000000000000	8c86c3ea-a36e-4dfc-a2c6-755d28a7fe67	{"action":"login","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-27 14:24:16.045331+00	
00000000-0000-0000-0000-000000000000	ebdd47b3-9008-4052-821f-fa9fc9b9ea67	{"action":"token_refreshed","actor_id":"fb6b83d8-1528-440a-851a-2ef159b28b65","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 14:44:57.594645+00	
00000000-0000-0000-0000-000000000000	b5465b7e-63da-4e04-9b92-698870c3704e	{"action":"token_revoked","actor_id":"fb6b83d8-1528-440a-851a-2ef159b28b65","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-27 14:44:57.598907+00	
00000000-0000-0000-0000-000000000000	c5b05a81-620b-4eee-aa98-5df9477a46a3	{"action":"token_refreshed","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-28 00:31:31.496955+00	
00000000-0000-0000-0000-000000000000	4d350900-456a-4d5d-b139-ff23e645965e	{"action":"token_revoked","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-28 00:31:31.512382+00	
00000000-0000-0000-0000-000000000000	8a5b5674-c54e-4ced-a273-a8aeb771333e	{"action":"logout","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-28 00:32:37.702522+00	
00000000-0000-0000-0000-000000000000	e23a856c-aa6b-4c7f-8520-916ce03c4e0a	{"action":"user_repeated_signup","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-05-28 00:34:03.54991+00	
00000000-0000-0000-0000-000000000000	bb84bdd5-f54b-4213-8dd5-ec9c9563dcaa	{"action":"login","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-28 00:34:22.653693+00	
00000000-0000-0000-0000-000000000000	c2cb48f4-98dc-4019-8133-4c532f4b3061	{"action":"logout","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-28 00:52:58.572252+00	
00000000-0000-0000-0000-000000000000	dde320e0-9f30-4e45-b33e-873fcac8573a	{"action":"user_repeated_signup","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-05-28 00:54:43.373352+00	
00000000-0000-0000-0000-000000000000	73b6b9f4-6f96-4a51-ad35-891dbf5fb595	{"action":"login","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-28 00:55:03.213738+00	
00000000-0000-0000-0000-000000000000	e61ca24f-76b2-496b-a095-969ba9d9c881	{"action":"logout","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-28 01:04:19.260424+00	
00000000-0000-0000-0000-000000000000	bfcf3b8e-4229-443c-95fe-d77758f0aaef	{"action":"user_recovery_requested","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-28 01:04:32.633576+00	
00000000-0000-0000-0000-000000000000	b16fab4c-471d-449a-974a-29f15a9fc3e1	{"action":"user_recovery_requested","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-28 01:08:05.793537+00	
00000000-0000-0000-0000-000000000000	981f5d75-fb0c-42c1-a737-9ef273684fd2	{"action":"user_recovery_requested","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-28 01:09:33.202319+00	
00000000-0000-0000-0000-000000000000	6a7a2ff7-2819-4d17-94bb-e745276c8909	{"action":"user_repeated_signup","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-05-28 01:11:35.508562+00	
00000000-0000-0000-0000-000000000000	6e55df7b-2a76-491f-87d7-829f84ae88dc	{"action":"login","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-28 01:11:51.826878+00	
00000000-0000-0000-0000-000000000000	2f7af658-bb13-4e1e-8e9f-d37daa61c0e7	{"action":"logout","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-28 01:22:32.668963+00	
00000000-0000-0000-0000-000000000000	8159504b-ca8e-43e4-a3ee-36d61aaf392b	{"action":"user_recovery_requested","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-28 01:23:10.88904+00	
00000000-0000-0000-0000-000000000000	8b37f136-6804-4334-9556-df2c7a6d957d	{"action":"login","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-28 01:23:33.674393+00	
00000000-0000-0000-0000-000000000000	83d91eca-a984-4b14-80f9-3fa7b2f7e9e2	{"action":"logout","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-28 01:23:57.898283+00	
00000000-0000-0000-0000-000000000000	cb79c1a1-2998-4edb-800f-44f936bed64b	{"action":"user_repeated_signup","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-05-28 01:24:54.793597+00	
00000000-0000-0000-0000-000000000000	929c2b45-a282-4dbe-b894-8052e64b77c8	{"action":"login","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-28 01:25:04.992435+00	
00000000-0000-0000-0000-000000000000	fbb64186-bcbc-4d0d-b567-909002deb059	{"action":"token_refreshed","actor_id":"fb6b83d8-1528-440a-851a-2ef159b28b65","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-28 01:51:03.050465+00	
00000000-0000-0000-0000-000000000000	932595bb-760f-43db-b013-0a278e7ce6f0	{"action":"token_revoked","actor_id":"fb6b83d8-1528-440a-851a-2ef159b28b65","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-28 01:51:03.05193+00	
00000000-0000-0000-0000-000000000000	8919d798-7de8-4ae4-a142-c3825300cd8f	{"action":"token_refreshed","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-28 02:28:30.120488+00	
00000000-0000-0000-0000-000000000000	467bfb0f-97be-4d55-99fb-7b7ae5c20472	{"action":"token_revoked","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-28 02:28:30.121994+00	
00000000-0000-0000-0000-000000000000	c7c55605-005a-42d1-922f-0d25fe60320f	{"action":"token_refreshed","actor_id":"fb6b83d8-1528-440a-851a-2ef159b28b65","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-28 02:49:24.791908+00	
00000000-0000-0000-0000-000000000000	73b7f6d4-535e-48c4-b17b-b90b7c00d42c	{"action":"token_revoked","actor_id":"fb6b83d8-1528-440a-851a-2ef159b28b65","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-28 02:49:24.793409+00	
00000000-0000-0000-0000-000000000000	f0759fbe-113e-451b-ae7a-e738da2c26d9	{"action":"logout","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-28 02:53:10.661672+00	
00000000-0000-0000-0000-000000000000	ba278b98-43b8-4cdf-8e38-f703343d9e12	{"action":"user_recovery_requested","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-28 02:53:45.055751+00	
00000000-0000-0000-0000-000000000000	b24cfc21-b0d8-43ab-815c-786f9d27f08d	{"action":"login","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-28 02:54:08.853048+00	
00000000-0000-0000-0000-000000000000	c312a98a-d7c3-40db-828c-2389b85882e9	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"jkoh0038@student.monash.edu","user_id":"853416ce-6f41-4333-a136-0dff211dc117","user_phone":""}}	2025-05-28 02:55:24.94592+00	
00000000-0000-0000-0000-000000000000	31a41f77-7f39-4e2c-b229-829bad7c98e1	{"action":"logout","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-28 02:55:47.540586+00	
00000000-0000-0000-0000-000000000000	1d3d2d5e-c636-4ac5-b5cc-0065cced1b1e	{"action":"user_repeated_signup","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-05-28 02:57:01.795685+00	
00000000-0000-0000-0000-000000000000	318853a1-e4bb-4bf2-ad14-debcec2238c2	{"action":"login","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-28 02:57:15.608597+00	
00000000-0000-0000-0000-000000000000	520d7f49-4ee2-46b6-b8ba-b965e4af4578	{"action":"logout","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-28 03:06:13.158123+00	
00000000-0000-0000-0000-000000000000	ea6285f4-50e0-4449-aaf4-3bbacb538f02	{"action":"user_recovery_requested","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-28 03:07:00.676409+00	
00000000-0000-0000-0000-000000000000	927d4065-b491-49f0-84c0-6c8bedf7bad3	{"action":"login","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-28 03:07:15.376257+00	
00000000-0000-0000-0000-000000000000	c8a71f12-d1df-4ada-bb89-aa3054b8dd02	{"action":"user_updated_password","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-28 03:07:23.249505+00	
00000000-0000-0000-0000-000000000000	d2f33ee5-16c3-40a0-81ca-5351f65de75f	{"action":"user_modified","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-28 03:07:23.250171+00	
00000000-0000-0000-0000-000000000000	af5eb0eb-12ff-4060-bb27-d715bf475526	{"action":"logout","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-28 03:07:48.114521+00	
00000000-0000-0000-0000-000000000000	cf4ce873-d28d-425e-98a7-bb6748ee57bd	{"action":"user_repeated_signup","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-05-28 03:08:45.054757+00	
00000000-0000-0000-0000-000000000000	410f6606-ea30-4ae3-8447-68ed7ce0fac3	{"action":"login","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-28 03:08:56.902774+00	
00000000-0000-0000-0000-000000000000	5e92bb04-9b2c-4780-873c-213b447803ef	{"action":"logout","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-28 03:15:44.715277+00	
00000000-0000-0000-0000-000000000000	1a0b1bf8-cbf7-4cac-a447-a48eb2e34d20	{"action":"user_recovery_requested","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-28 03:18:19.007518+00	
00000000-0000-0000-0000-000000000000	1ff4c285-028f-406f-91a2-2161c7929f6d	{"action":"user_updated_password","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-28 03:18:50.64473+00	
00000000-0000-0000-0000-000000000000	5da0b161-3b88-4429-950f-93b70a159a40	{"action":"user_modified","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-28 03:18:50.646583+00	
00000000-0000-0000-0000-000000000000	9ec608f1-1cd8-463c-82e9-0fc413cee9af	{"action":"logout","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-28 03:22:01.026073+00	
00000000-0000-0000-0000-000000000000	d3b78696-c3ca-4404-b293-e5f174554987	{"action":"user_recovery_requested","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-28 03:22:16.032772+00	
00000000-0000-0000-0000-000000000000	1324a5c6-2d1f-471f-8382-ba0bc322bff9	{"action":"login","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-28 03:22:35.513769+00	
00000000-0000-0000-0000-000000000000	ce32c6cc-1cae-4433-a855-6b2a6f0a1774	{"action":"logout","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-28 03:22:39.636165+00	
00000000-0000-0000-0000-000000000000	0f449b67-f768-471c-9400-3a27ace6c72a	{"action":"user_recovery_requested","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-28 03:24:59.441755+00	
00000000-0000-0000-0000-000000000000	8b3c46ff-4ce2-4dfa-aa04-6168406c2446	{"action":"login","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-28 03:25:18.892192+00	
00000000-0000-0000-0000-000000000000	88e6c2bb-f311-4e0d-9257-53121da9d867	{"action":"logout","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-28 03:25:28.848955+00	
00000000-0000-0000-0000-000000000000	71cdff87-b047-473b-a239-14c797ad5b73	{"action":"user_repeated_signup","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-05-28 03:26:30.134371+00	
00000000-0000-0000-0000-000000000000	5d10fc79-8d6a-4fb1-bb72-0b62b780e882	{"action":"login","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-28 03:26:39.970727+00	
00000000-0000-0000-0000-000000000000	2be919d6-553e-4cd4-91ed-7c0774100c94	{"action":"logout","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-28 03:34:38.866312+00	
00000000-0000-0000-0000-000000000000	2532d032-83d2-4ded-bb2c-dafa8a54e184	{"action":"user_recovery_requested","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-28 03:35:06.91834+00	
00000000-0000-0000-0000-000000000000	f2c97680-14ef-4d8d-969f-40f8a89e78b1	{"action":"login","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-28 03:35:24.445259+00	
00000000-0000-0000-0000-000000000000	8b6bafa8-57eb-486f-ba4b-8deee56800d0	{"action":"logout","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-28 03:35:32.995614+00	
00000000-0000-0000-0000-000000000000	27b8c82f-a9bb-4e26-8698-310cc6c75084	{"action":"user_repeated_signup","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-05-28 03:36:33.526219+00	
00000000-0000-0000-0000-000000000000	b4f25f12-2a52-497f-b145-f010cd9cc181	{"action":"login","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-28 03:36:58.353994+00	
00000000-0000-0000-0000-000000000000	0e188da8-affc-4ee6-bedf-b8fac8fcc1a1	{"action":"token_refreshed","actor_id":"fb6b83d8-1528-440a-851a-2ef159b28b65","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-28 04:36:00.21897+00	
00000000-0000-0000-0000-000000000000	9a2b2949-e4ba-45e4-aebd-17dfd5c9eb83	{"action":"token_revoked","actor_id":"fb6b83d8-1528-440a-851a-2ef159b28b65","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-28 04:36:00.221104+00	
00000000-0000-0000-0000-000000000000	bd11184d-0e58-4508-9c82-550e82c2bf77	{"action":"token_refreshed","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-28 04:43:50.825971+00	
00000000-0000-0000-0000-000000000000	b01bb5fa-8b93-483d-a1f9-fb30295abaa4	{"action":"token_revoked","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-28 04:43:50.826812+00	
00000000-0000-0000-0000-000000000000	97c80705-5dec-4e31-a965-8b0617dd0ea0	{"action":"logout","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-28 04:43:53.852+00	
00000000-0000-0000-0000-000000000000	bcd7991d-f817-488e-90a2-68bebbf1377e	{"action":"user_recovery_requested","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-28 04:47:15.285139+00	
00000000-0000-0000-0000-000000000000	aa293aad-e758-4b02-84c4-dfdbb1b69d48	{"action":"login","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-28 04:47:34.678805+00	
00000000-0000-0000-0000-000000000000	c599a291-8ecc-42d3-8b32-3d32380346a4	{"action":"logout","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-28 04:47:42.478306+00	
00000000-0000-0000-0000-000000000000	6fa8c5d4-0b65-4cd9-bc27-364dcdf135d1	{"action":"user_repeated_signup","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-05-28 04:48:24.880813+00	
00000000-0000-0000-0000-000000000000	aba5fcb0-5173-4c03-b783-37caaefac84a	{"action":"login","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-28 04:48:44.494549+00	
00000000-0000-0000-0000-000000000000	fa6c92af-5ee0-4a7c-bfe9-d362f93b8ebe	{"action":"logout","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-28 05:11:02.366679+00	
00000000-0000-0000-0000-000000000000	eb83ff15-9fce-4ead-b867-bb2e9153de80	{"action":"user_recovery_requested","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-28 05:12:32.719582+00	
00000000-0000-0000-0000-000000000000	bebf79b7-8aa0-4328-a616-8d02d39a6ad5	{"action":"login","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-28 05:12:54.397783+00	
00000000-0000-0000-0000-000000000000	880a1812-8432-4a55-ad38-6032bc2eba9c	{"action":"logout","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-28 05:13:04.123987+00	
00000000-0000-0000-0000-000000000000	4039ae95-1736-402d-ab57-111f616ed4d6	{"action":"user_repeated_signup","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-05-28 05:13:50.262933+00	
00000000-0000-0000-0000-000000000000	be1a2e60-efad-43da-800f-cd6a0509387c	{"action":"login","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-28 05:14:12.541833+00	
00000000-0000-0000-0000-000000000000	19285078-3c63-4386-97cf-176c37cb45ea	{"action":"logout","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-28 05:18:03.060755+00	
00000000-0000-0000-0000-000000000000	5491d0b5-e164-4ed4-90c0-21e1c1bcfd6d	{"action":"user_recovery_requested","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-28 05:29:42.929808+00	
00000000-0000-0000-0000-000000000000	f15d5f50-072a-4ce5-aec3-0b9a5eac53ba	{"action":"login","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-28 05:30:02.328746+00	
00000000-0000-0000-0000-000000000000	63ac44ee-43ea-4c6a-a724-57f2faaab13a	{"action":"logout","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-28 05:30:13.174927+00	
00000000-0000-0000-0000-000000000000	d3905e6b-bc40-4921-983e-26ee6e6cae8a	{"action":"user_repeated_signup","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-05-28 05:30:55.310358+00	
00000000-0000-0000-0000-000000000000	433926e7-45ee-48ed-9eb5-f3ee1acbd5a4	{"action":"login","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-28 05:31:15.309146+00	
00000000-0000-0000-0000-000000000000	4a8c0c69-d868-4612-b8b3-bec6cba98e7f	{"action":"token_refreshed","actor_id":"fb6b83d8-1528-440a-851a-2ef159b28b65","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-28 05:40:44.416631+00	
00000000-0000-0000-0000-000000000000	dad1687d-894f-4853-bdf6-7d58b593a64c	{"action":"token_revoked","actor_id":"fb6b83d8-1528-440a-851a-2ef159b28b65","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-28 05:40:44.417528+00	
00000000-0000-0000-0000-000000000000	f697c1ec-a415-431f-b6e3-8ff39668abfd	{"action":"logout","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-28 05:43:00.017019+00	
00000000-0000-0000-0000-000000000000	2ba95c58-1d49-4f8e-9e39-3d105104bcd8	{"action":"login","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-28 05:58:12.708483+00	
00000000-0000-0000-0000-000000000000	517a83b3-25dd-496b-af41-cdba601a6877	{"action":"logout","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-28 06:01:41.74921+00	
00000000-0000-0000-0000-000000000000	bb20715f-a0c1-487f-96ee-ff2fe8871979	{"action":"user_recovery_requested","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-28 06:05:52.63699+00	
00000000-0000-0000-0000-000000000000	e3d74730-323c-4a44-9eb0-0235236be5ca	{"action":"user_recovery_requested","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-28 06:05:55.071712+00	
00000000-0000-0000-0000-000000000000	f50606c8-a508-4837-8c59-bb32d38acff4	{"action":"user_repeated_signup","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-05-28 06:07:02.52799+00	
00000000-0000-0000-0000-000000000000	ead0ebb5-6258-4690-b145-c581786661cf	{"action":"login","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-28 06:07:23.310374+00	
00000000-0000-0000-0000-000000000000	168fb9b6-172e-4120-902b-9bd9d080029d	{"action":"logout","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-05-28 06:10:26.877417+00	
00000000-0000-0000-0000-000000000000	0803fefd-99a3-4c0c-9f04-ba13681f0ba5	{"action":"user_recovery_requested","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-28 06:43:56.239576+00	
00000000-0000-0000-0000-000000000000	642205d8-36a1-4388-a08f-3796c9b169e6	{"action":"user_recovery_requested","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-05-28 06:43:57.769233+00	
00000000-0000-0000-0000-000000000000	a0b36921-2780-4e3f-b103-b32efdd0ba19	{"action":"user_repeated_signup","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-05-28 06:45:01.894693+00	
00000000-0000-0000-0000-000000000000	9e9dda98-fb34-4d70-8a59-8f1cefddefa0	{"action":"login","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-05-28 06:45:19.577466+00	
00000000-0000-0000-0000-000000000000	0e85ff06-a844-43ae-9194-a84c0858eead	{"action":"token_refreshed","actor_id":"fb6b83d8-1528-440a-851a-2ef159b28b65","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-29 01:46:18.6594+00	
00000000-0000-0000-0000-000000000000	a5971048-998c-41fc-a195-009e9635dbdd	{"action":"token_revoked","actor_id":"fb6b83d8-1528-440a-851a-2ef159b28b65","actor_name":"Teo Shi Yang","actor_username":"wilsonteoshiyang@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-05-29 01:46:18.6785+00	
00000000-0000-0000-0000-000000000000	d792049c-ec22-4407-a5bc-721619c3021d	{"action":"token_refreshed","actor_id":"be560e00-5f19-49d7-b245-76852457e398","actor_name":"Chong Chi Yang","actor_username":"ccho0092@student.monash.edu","actor_via_sso":false,"log_type":"token"}	2025-05-29 03:36:42.797807+00	
00000000-0000-0000-0000-000000000000	04b8ef52-3ce1-4a58-8513-0976f395e1cc	{"action":"token_revoked","actor_id":"be560e00-5f19-49d7-b245-76852457e398","actor_name":"Chong Chi Yang","actor_username":"ccho0092@student.monash.edu","actor_via_sso":false,"log_type":"token"}	2025-05-29 03:36:42.801797+00	
00000000-0000-0000-0000-000000000000	8dd8d362-5462-404e-8289-b5fe534460b5	{"action":"logout","actor_id":"be560e00-5f19-49d7-b245-76852457e398","actor_name":"Chong Chi Yang","actor_username":"ccho0092@student.monash.edu","actor_via_sso":false,"log_type":"account"}	2025-05-29 04:03:09.636865+00	
00000000-0000-0000-0000-000000000000	fb19d101-efbb-452b-8a24-371562fd15ae	{"action":"login","actor_id":"ba5e41c4-8085-4d08-a656-faca201d6ba3","actor_name":"testing","actor_username":"jingle.koh@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-06-01 09:06:44.174447+00	
\.


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at) FROM stdin;
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
c1624ddd-be2e-46b1-b166-572f3c222a06	c1624ddd-be2e-46b1-b166-572f3c222a06	{"sub": "c1624ddd-be2e-46b1-b166-572f3c222a06", "email": "hee.karyan@gmail.com", "full_name": "kar yan", "email_verified": false, "phone_verified": false}	email	2025-05-18 05:53:46.777546+00	2025-05-18 05:53:46.777599+00	2025-05-18 05:53:46.777599+00	bfa48261-10c3-4a3a-9cf1-28411f6b619e
ba5e41c4-8085-4d08-a656-faca201d6ba3	ba5e41c4-8085-4d08-a656-faca201d6ba3	{"sub": "ba5e41c4-8085-4d08-a656-faca201d6ba3", "email": "jingle.koh@gmail.com", "full_name": "testing", "email_verified": false, "phone_verified": false}	email	2025-05-23 13:05:17.9225+00	2025-05-23 13:05:17.922559+00	2025-05-23 13:05:17.922559+00	110de0e4-b78b-493d-bac0-25cd6e6524cc
be560e00-5f19-49d7-b245-76852457e398	be560e00-5f19-49d7-b245-76852457e398	{"sub": "be560e00-5f19-49d7-b245-76852457e398", "email": "ccho0092@student.monash.edu", "full_name": "Chong Chi Yang", "email_verified": false, "phone_verified": false}	email	2025-05-26 14:06:21.248069+00	2025-05-26 14:06:21.248123+00	2025-05-26 14:06:21.248123+00	68996ea7-b954-4fed-bba9-39512705e8f7
fb6b83d8-1528-440a-851a-2ef159b28b65	fb6b83d8-1528-440a-851a-2ef159b28b65	{"sub": "fb6b83d8-1528-440a-851a-2ef159b28b65", "email": "wilsonteoshiyang@gmail.com", "full_name": "Teo Shi Yang", "email_verified": false, "phone_verified": false}	email	2025-05-27 05:20:12.721981+00	2025-05-27 05:20:12.72203+00	2025-05-27 05:20:12.72203+00	6816a503-1246-4a94-a136-651abc29a151
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
f7a68ed5-0768-41bb-85c0-f72687eea9b5	2025-05-28 06:45:19.585787+00	2025-05-28 06:45:19.585787+00	password	131a0abc-2510-4bfb-813e-7ff8c4dacfa1
464e9f59-483a-454f-bb02-9106fc9c203f	2025-06-01 09:06:44.243309+00	2025-06-01 09:06:44.243309+00	password	e973b9a2-8de3-4739-bae0-159e645ab332
0f4f0a3b-14f6-4042-ad06-c3f5636fbd7e	2025-05-27 05:20:12.739285+00	2025-05-27 05:20:12.739285+00	password	9e3510fd-7fb3-4538-8bc4-8cab80f57caa
5328cdd9-58c2-42eb-9176-67d282d46761	2025-05-27 10:34:45.407751+00	2025-05-27 10:34:45.407751+00	password	ca4521df-1a5b-4271-af06-71cdb31a3ea0
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid) FROM stdin;
\.


--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at) FROM stdin;
e9763570-5bba-4e74-9265-70754a9ac4f0	ba5e41c4-8085-4d08-a656-faca201d6ba3	recovery_token	7497e7b3b041183dc71a832b04aab1aa08fd75cda7691301ca25514d	jingle.koh@gmail.com	2025-05-28 06:44:01.216335	2025-05-28 06:44:01.216335
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
00000000-0000-0000-0000-000000000000	106	toyyqoqmmfxh	fb6b83d8-1528-440a-851a-2ef159b28b65	t	2025-05-27 09:30:01.796105+00	2025-05-27 10:28:57.619322+00	ty4tmxuzjxf7	0f4f0a3b-14f6-4042-ad06-c3f5636fbd7e
00000000-0000-0000-0000-000000000000	110	lzbcfby4fzw3	c1624ddd-be2e-46b1-b166-572f3c222a06	t	2025-05-27 10:34:45.404012+00	2025-05-27 11:39:30.053066+00	\N	5328cdd9-58c2-42eb-9176-67d282d46761
00000000-0000-0000-0000-000000000000	109	dywdqihbvxx5	fb6b83d8-1528-440a-851a-2ef159b28b65	t	2025-05-27 10:28:57.620953+00	2025-05-27 11:49:44.607683+00	toyyqoqmmfxh	0f4f0a3b-14f6-4042-ad06-c3f5636fbd7e
00000000-0000-0000-0000-000000000000	113	yrktf7ezmhvv	fb6b83d8-1528-440a-851a-2ef159b28b65	t	2025-05-27 11:49:44.608842+00	2025-05-27 12:48:40.842217+00	dywdqihbvxx5	0f4f0a3b-14f6-4042-ad06-c3f5636fbd7e
00000000-0000-0000-0000-000000000000	111	ik3q55j7lkbl	c1624ddd-be2e-46b1-b166-572f3c222a06	t	2025-05-27 11:39:30.063662+00	2025-05-27 12:56:35.393161+00	lzbcfby4fzw3	5328cdd9-58c2-42eb-9176-67d282d46761
00000000-0000-0000-0000-000000000000	118	lbayuu6asthc	c1624ddd-be2e-46b1-b166-572f3c222a06	f	2025-05-27 12:56:35.395367+00	2025-05-27 12:56:35.395367+00	ik3q55j7lkbl	5328cdd9-58c2-42eb-9176-67d282d46761
00000000-0000-0000-0000-000000000000	117	4as5urx55bdq	fb6b83d8-1528-440a-851a-2ef159b28b65	t	2025-05-27 12:48:40.843452+00	2025-05-27 13:46:45.886469+00	yrktf7ezmhvv	0f4f0a3b-14f6-4042-ad06-c3f5636fbd7e
00000000-0000-0000-0000-000000000000	120	h7cpsos6c2d7	fb6b83d8-1528-440a-851a-2ef159b28b65	t	2025-05-27 13:46:45.889404+00	2025-05-27 14:44:57.599411+00	4as5urx55bdq	0f4f0a3b-14f6-4042-ad06-c3f5636fbd7e
00000000-0000-0000-0000-000000000000	122	sbgn7b66qz4a	fb6b83d8-1528-440a-851a-2ef159b28b65	t	2025-05-27 14:44:57.602827+00	2025-05-28 01:51:03.053021+00	h7cpsos6c2d7	0f4f0a3b-14f6-4042-ad06-c3f5636fbd7e
00000000-0000-0000-0000-000000000000	129	gtjqgtkxkgcw	fb6b83d8-1528-440a-851a-2ef159b28b65	t	2025-05-28 01:51:03.055169+00	2025-05-28 02:49:24.793931+00	sbgn7b66qz4a	0f4f0a3b-14f6-4042-ad06-c3f5636fbd7e
00000000-0000-0000-0000-000000000000	97	kez56y4qslqb	fb6b83d8-1528-440a-851a-2ef159b28b65	t	2025-05-27 05:20:12.736512+00	2025-05-27 06:18:32.411457+00	\N	0f4f0a3b-14f6-4042-ad06-c3f5636fbd7e
00000000-0000-0000-0000-000000000000	99	34jnunaeg5pt	fb6b83d8-1528-440a-851a-2ef159b28b65	t	2025-05-27 06:18:32.413226+00	2025-05-27 07:32:57.07312+00	kez56y4qslqb	0f4f0a3b-14f6-4042-ad06-c3f5636fbd7e
00000000-0000-0000-0000-000000000000	131	jitsx4w7asxe	fb6b83d8-1528-440a-851a-2ef159b28b65	t	2025-05-28 02:49:24.794536+00	2025-05-28 04:36:00.221682+00	gtjqgtkxkgcw	0f4f0a3b-14f6-4042-ad06-c3f5636fbd7e
00000000-0000-0000-0000-000000000000	101	ya2jxafef24z	fb6b83d8-1528-440a-851a-2ef159b28b65	t	2025-05-27 07:32:57.076259+00	2025-05-27 08:31:55.064285+00	34jnunaeg5pt	0f4f0a3b-14f6-4042-ad06-c3f5636fbd7e
00000000-0000-0000-0000-000000000000	103	ty4tmxuzjxf7	fb6b83d8-1528-440a-851a-2ef159b28b65	t	2025-05-27 08:31:55.064985+00	2025-05-27 09:30:01.79381+00	ya2jxafef24z	0f4f0a3b-14f6-4042-ad06-c3f5636fbd7e
00000000-0000-0000-0000-000000000000	142	evhstqaot26q	fb6b83d8-1528-440a-851a-2ef159b28b65	t	2025-05-28 04:36:00.222394+00	2025-05-28 05:40:44.418859+00	jitsx4w7asxe	0f4f0a3b-14f6-4042-ad06-c3f5636fbd7e
00000000-0000-0000-0000-000000000000	153	cchlrq57ewpa	ba5e41c4-8085-4d08-a656-faca201d6ba3	f	2025-05-28 06:45:19.582165+00	2025-05-28 06:45:19.582165+00	\N	f7a68ed5-0768-41bb-85c0-f72687eea9b5
00000000-0000-0000-0000-000000000000	150	2z2lokr66lpf	fb6b83d8-1528-440a-851a-2ef159b28b65	t	2025-05-28 05:40:44.420317+00	2025-05-29 01:46:18.680849+00	evhstqaot26q	0f4f0a3b-14f6-4042-ad06-c3f5636fbd7e
00000000-0000-0000-0000-000000000000	154	fahl56sgqrgr	fb6b83d8-1528-440a-851a-2ef159b28b65	f	2025-05-29 01:46:18.700863+00	2025-05-29 01:46:18.700863+00	2z2lokr66lpf	0f4f0a3b-14f6-4042-ad06-c3f5636fbd7e
00000000-0000-0000-0000-000000000000	156	to3zmn2uw6zf	ba5e41c4-8085-4d08-a656-faca201d6ba3	f	2025-06-01 09:06:44.21655+00	2025-06-01 09:06:44.21655+00	\N	464e9f59-483a-454f-bb02-9106fc9c203f
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
20230322519590
20230402418590
20230411005111
20230508135423
20230523124323
20230818113222
20230914180801
20231027141322
20231114161723
20231117164230
20240115144230
20240214120130
20240306115329
20240314092811
20240427152123
20240612123726
20240729123726
20240802193726
20240806073726
20241009103726
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag) FROM stdin;
f7a68ed5-0768-41bb-85c0-f72687eea9b5	ba5e41c4-8085-4d08-a656-faca201d6ba3	2025-05-28 06:45:19.578894+00	2025-05-28 06:45:19.578894+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36	118.139.138.158	\N
0f4f0a3b-14f6-4042-ad06-c3f5636fbd7e	fb6b83d8-1528-440a-851a-2ef159b28b65	2025-05-27 05:20:12.733261+00	2025-05-29 01:46:18.717316+00	\N	aal1	\N	2025-05-29 01:46:18.71724	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36	113.211.215.104	\N
5328cdd9-58c2-42eb-9176-67d282d46761	c1624ddd-be2e-46b1-b166-572f3c222a06	2025-05-27 10:34:45.402337+00	2025-05-27 12:56:35.399284+00	\N	aal1	\N	2025-05-27 12:56:35.399211	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.6 Safari/605.1.15	121.123.58.235	\N
464e9f59-483a-454f-bb02-9106fc9c203f	ba5e41c4-8085-4d08-a656-faca201d6ba3	2025-06-01 09:06:44.199335+00	2025-06-01 09:06:44.199335+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36	182.62.37.0	\N
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
00000000-0000-0000-0000-000000000000	fb6b83d8-1528-440a-851a-2ef159b28b65	authenticated	authenticated	wilsonteoshiyang@gmail.com	$2a$10$LZTHM.MjxjDDGWrrTKwm1OPK/ociIp.xDckN46PIPDBRqKFo/GqJ.	2025-05-27 05:20:12.727258+00	\N		\N		\N			\N	2025-05-27 05:20:12.733176+00	{"provider": "email", "providers": ["email"]}	{"sub": "fb6b83d8-1528-440a-851a-2ef159b28b65", "email": "wilsonteoshiyang@gmail.com", "full_name": "Teo Shi Yang", "email_verified": true, "phone_verified": false}	\N	2025-05-27 05:20:12.704794+00	2025-05-29 01:46:18.709818+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	be560e00-5f19-49d7-b245-76852457e398	authenticated	authenticated	ccho0092@student.monash.edu	$2a$10$e5fFEqbSMlmG3pU68gM4wucqaaP1BYgfxEty9EEjYE19oHvGKESTq	2025-05-26 14:06:21.258004+00	\N		\N		\N			\N	2025-05-26 14:06:21.265869+00	{"provider": "email", "providers": ["email"]}	{"sub": "be560e00-5f19-49d7-b245-76852457e398", "email": "ccho0092@student.monash.edu", "full_name": "Chong Chi Yang", "email_verified": true, "phone_verified": false}	\N	2025-05-26 14:06:21.225984+00	2025-05-29 03:36:42.811467+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	ba5e41c4-8085-4d08-a656-faca201d6ba3	authenticated	authenticated	jingle.koh@gmail.com	$2a$10$dkUU4u0dfrfptIqAZdAA0eH8MgHbxDydc9ykS/v9tsZwvXXbuvsDi	2025-05-23 13:05:17.927909+00	\N		\N	7497e7b3b041183dc71a832b04aab1aa08fd75cda7691301ca25514d	2025-05-28 06:43:57.770001+00			\N	2025-06-01 09:06:44.198587+00	{"provider": "email", "providers": ["email"]}	{"sub": "ba5e41c4-8085-4d08-a656-faca201d6ba3", "email": "jingle.koh@gmail.com", "full_name": "testing", "email_verified": true, "phone_verified": false}	\N	2025-05-23 13:05:17.909398+00	2025-06-01 09:06:44.238583+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	c1624ddd-be2e-46b1-b166-572f3c222a06	authenticated	authenticated	hee.karyan@gmail.com	$2a$10$uhEMjssRXQuuPdxGoJoPzOI/RjQgRxSn608wCnIeSRgi5Ogr.Wz0e	2025-05-18 05:53:46.782932+00	\N		\N		2025-05-23 14:23:58.301706+00			\N	2025-05-27 10:34:45.402265+00	{"provider": "email", "providers": ["email"]}	{"sub": "c1624ddd-be2e-46b1-b166-572f3c222a06", "email": "hee.karyan@gmail.com", "full_name": "kar yan", "email_verified": true, "phone_verified": false}	\N	2025-05-18 05:53:46.763019+00	2025-05-27 12:56:35.396615+00	\N	\N			\N		0	\N		\N	f	\N	f
\.


--
-- Data for Name: analyzed_subject; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.analyzed_subject (id, user_id, identification_no, name, final_label, created_at, session_number, session_id, ended_at, final_prob) FROM stdin;
71	fb6b83d8-1528-440a-851a-2ef159b28b65	1	t	\N	2025-05-27 08:59:54.177692+00	6	fb6b83d8-1528-440a-851a-2ef159b28b65--1-6	2025-05-27 08:59:54.340519+00	\N
72	fb6b83d8-1528-440a-851a-2ef159b28b65	1	t	t	2025-05-27 09:03:07.279274+00	7	fb6b83d8-1528-440a-851a-2ef159b28b65--1-7	2025-05-27 09:03:24.074815+00	0.8340000000000001
109	fb6b83d8-1528-440a-851a-2ef159b28b65	1	t	t	2025-05-27 13:30:14.608497+00	13	fb6b83d8-1528-440a-851a-2ef159b28b65--1-13	2025-05-27 13:30:19.178192+00	0.8767418265342712
110	fb6b83d8-1528-440a-851a-2ef159b28b65	1	t	t	2025-05-27 13:30:24.099606+00	14	fb6b83d8-1528-440a-851a-2ef159b28b65--1-14	2025-05-27 13:30:28.207853+00	0.7296575307846069
111	fb6b83d8-1528-440a-851a-2ef159b28b65	1	t	t	2025-05-27 13:30:43.585887+00	15	fb6b83d8-1528-440a-851a-2ef159b28b65--1-15	2025-05-27 13:30:48.692232+00	0.6019572019577026
112	fb6b83d8-1528-440a-851a-2ef159b28b65	1	t	t	2025-05-27 13:30:51.41235+00	16	fb6b83d8-1528-440a-851a-2ef159b28b65--1-16	2025-05-27 13:30:55.85789+00	0.537830114364624
73	fb6b83d8-1528-440a-851a-2ef159b28b65	1	t	t	2025-05-27 09:03:32.46078+00	8	fb6b83d8-1528-440a-851a-2ef159b28b65--1-8	2025-05-27 09:04:33.324715+00	0.8190000000000001
113	fb6b83d8-1528-440a-851a-2ef159b28b65	1	t	t	2025-05-27 13:30:58.393164+00	17	fb6b83d8-1528-440a-851a-2ef159b28b65--1-17	2025-05-27 13:31:21.51128+00	0.537830114364624
114	fb6b83d8-1528-440a-851a-2ef159b28b65	1	t	f	2025-05-27 13:31:30.923612+00	18	fb6b83d8-1528-440a-851a-2ef159b28b65--1-18	2025-05-27 13:31:36.168097+00	0.2207653969526291
58	fb6b83d8-1528-440a-851a-2ef159b28b65	1	t	\N	2025-05-27 08:01:25.04862+00	1	fb6b83d8-1528-440a-851a-2ef159b28b65--1-1	2025-05-27 08:01:25.247143+00	\N
60	fb6b83d8-1528-440a-851a-2ef159b28b65	1	t	t	2025-05-27 08:04:22.748837+00	2	fb6b83d8-1528-440a-851a-2ef159b28b65--1-2	2025-05-27 08:04:23.788402+00	1.01
61	fb6b83d8-1528-440a-851a-2ef159b28b65	1	t	t	2025-05-27 08:04:27.406087+00	3	fb6b83d8-1528-440a-851a-2ef159b28b65--1-3	2025-05-27 08:04:49.046601+00	0.976
62	fb6b83d8-1528-440a-851a-2ef159b28b65	1	t	\N	2025-05-27 08:10:18.137267+00	4	fb6b83d8-1528-440a-851a-2ef159b28b65--1-4	2025-05-27 08:10:18.349584+00	\N
63	fb6b83d8-1528-440a-851a-2ef159b28b65	1	t	f	2025-05-27 08:11:31.642856+00	5	fb6b83d8-1528-440a-851a-2ef159b28b65--1-5	2025-05-27 08:12:03.44945+00	0.602
103	fb6b83d8-1528-440a-851a-2ef159b28b65	1	t	\N	2025-05-27 13:23:10.442615+00	9	fb6b83d8-1528-440a-851a-2ef159b28b65--1-9	2025-05-27 13:23:10.628587+00	\N
104	fb6b83d8-1528-440a-851a-2ef159b28b65	1	t	t	2025-05-27 13:24:16.67015+00	10	fb6b83d8-1528-440a-851a-2ef159b28b65--1-10	2025-05-27 13:24:35.156087+00	0.618
105	fb6b83d8-1528-440a-851a-2ef159b28b65	1	t	t	2025-05-27 13:24:59.414596+00	11	fb6b83d8-1528-440a-851a-2ef159b28b65--1-11	2025-05-27 13:25:24.836801+00	0.602
108	fb6b83d8-1528-440a-851a-2ef159b28b65	1	t	f	2025-05-27 13:28:10.604015+00	12	fb6b83d8-1528-440a-851a-2ef159b28b65--1-12	2025-05-27 13:28:14.025221+00	\N
150	ba5e41c4-8085-4d08-a656-faca201d6ba3	3456789	john	t	2025-05-28 05:42:33.50853+00	1	ba5e41c4-8085-4d08-a656-faca201d6ba3--john--3456789-1	2025-05-28 05:42:49.055147+00	0.8926540017127991
115	fb6b83d8-1528-440a-851a-2ef159b28b65	1	t	f	2025-05-27 13:31:41.639696+00	19	fb6b83d8-1528-440a-851a-2ef159b28b65--1-19	2025-05-27 13:31:47.465727+00	0.3884170949459076
116	fb6b83d8-1528-440a-851a-2ef159b28b65	1	t	f	2025-05-27 13:31:54.147196+00	20	fb6b83d8-1528-440a-851a-2ef159b28b65--1-20	2025-05-27 13:32:02.431966+00	0.4395708441734314
117	fb6b83d8-1528-440a-851a-2ef159b28b65	1	t	t	2025-05-27 13:32:06.169369+00	21	fb6b83d8-1528-440a-851a-2ef159b28b65--1-21	2025-05-27 13:32:12.192375+00	0.5879147052764893
118	fb6b83d8-1528-440a-851a-2ef159b28b65	1	t	t	2025-05-27 13:32:40.981283+00	22	fb6b83d8-1528-440a-851a-2ef159b28b65--1-22	2025-05-27 13:32:46.046993+00	0.6175305843353271
119	fb6b83d8-1528-440a-851a-2ef159b28b65	1	t	t	2025-05-27 13:32:48.953529+00	23	fb6b83d8-1528-440a-851a-2ef159b28b65--1-23	2025-05-27 13:32:56.304451+00	0.5365042686462402
120	fb6b83d8-1528-440a-851a-2ef159b28b65	1	t	\N	2025-05-27 13:32:58.925407+00	24	fb6b83d8-1528-440a-851a-2ef159b28b65--1-24	2025-05-27 13:32:59.158226+00	\N
121	ba5e41c4-8085-4d08-a656-faca201d6ba3	1	je	f	2025-05-27 13:34:09.221921+00	3	ba5e41c4-8085-4d08-a656-faca201d6ba3--je--1-3	2025-05-27 13:34:34.803422+00	0.1911606341600418
122	ba5e41c4-8085-4d08-a656-faca201d6ba3	1	je	t	2025-05-27 13:35:07.025888+00	4	ba5e41c4-8085-4d08-a656-faca201d6ba3--je--1-4	2025-05-27 13:35:24.799136+00	0.7633548378944397
123	fb6b83d8-1528-440a-851a-2ef159b28b65	1	t	t	2025-05-27 13:36:21.014084+00	25	fb6b83d8-1528-440a-851a-2ef159b28b65--t--1-25	2025-05-27 13:36:28.409322+00	0.9117684364318848
124	fb6b83d8-1528-440a-851a-2ef159b28b65	1	t	t	2025-05-27 13:36:32.317211+00	26	fb6b83d8-1528-440a-851a-2ef159b28b65--t--1-26	2025-05-27 13:36:35.627918+00	0.9034883379936218
125	fb6b83d8-1528-440a-851a-2ef159b28b65	1	t	t	2025-05-27 13:36:57.954327+00	27	fb6b83d8-1528-440a-851a-2ef159b28b65--t--1-27	2025-05-27 13:37:04.284904+00	0.5890480875968933
126	fb6b83d8-1528-440a-851a-2ef159b28b65	1	t	f	2025-05-27 13:37:06.141057+00	28	fb6b83d8-1528-440a-851a-2ef159b28b65--t--1-28	2025-05-27 13:37:14.868331+00	0.11255443096160889
127	fb6b83d8-1528-440a-851a-2ef159b28b65	1	t	t	2025-05-27 13:37:19.368993+00	29	fb6b83d8-1528-440a-851a-2ef159b28b65--t--1-29	2025-05-27 13:37:26.55253+00	0.9388970136642456
128	fb6b83d8-1528-440a-851a-2ef159b28b65	1	t	t	2025-05-27 13:37:30.361586+00	30	fb6b83d8-1528-440a-851a-2ef159b28b65--t--1-30	2025-05-27 13:37:37.675593+00	0.9966772794723511
156	ba5e41c4-8085-4d08-a656-faca201d6ba3	0	tt	t	2025-06-01 09:10:48.699336+00	3	ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-3	2025-06-01 09:11:49.134262+00	0.7547886371612549
152	ba5e41c4-8085-4d08-a656-faca201d6ba3	1	Koh Jing En	t	2025-05-28 06:47:15.30052+00	1	ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-1	2025-05-28 06:48:02.588638+00	0.7473343014717102
153	ba5e41c4-8085-4d08-a656-faca201d6ba3	1	Koh Jing En	t	2025-05-28 06:48:13.810606+00	2	ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-2	2025-05-28 06:49:20.855486+00	0.5965272784233093
154	ba5e41c4-8085-4d08-a656-faca201d6ba3	0	tt	t	2025-06-01 09:07:12.829828+00	1	ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-1	2025-06-01 09:09:36.083532+00	0.6062354445457458
155	ba5e41c4-8085-4d08-a656-faca201d6ba3	0	tt	f	2025-06-01 09:09:44.461922+00	2	ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-2	2025-06-01 09:10:26.966509+00	0.261155903339386
\.


--
-- Data for Name: session_video; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.session_video (id, subject_id, created_at, frame_index, chunk_url, user_id, session_id) FROM stdin;
a0c258cb-1ed7-4bf3-9e14-f2044f64b3e1	152	2025-05-28 06:47:38.019661	1	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-1_1748414857640.webm	ba5e41c4-8085-4d08-a656-faca201d6ba3	ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-1
b40f636f-5430-4918-af4a-e8dcd491c115	152	2025-05-28 06:48:02.423365	2	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-1_1748414858015.webm	ba5e41c4-8085-4d08-a656-faca201d6ba3	ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-1
bc07dd29-6679-4b8a-a001-9d94a4cea7d0	152	2025-05-28 06:48:02.537673	3	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-1_1748414861568.webm	ba5e41c4-8085-4d08-a656-faca201d6ba3	ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-1
da3aea1a-b6a1-4e69-b5b9-56306adc2118	153	2025-05-28 06:49:12.250102	1	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-2_1748414951841.webm	ba5e41c4-8085-4d08-a656-faca201d6ba3	ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-2
4fa0e583-f2a7-4839-98b6-0f697042942e	153	2025-05-28 06:49:13.335138	2	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-2_1748414953072.webm	ba5e41c4-8085-4d08-a656-faca201d6ba3	ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-2
e7441734-a826-4d72-a14b-05a3307be56e	153	2025-05-28 06:49:19.741423	3	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-2_1748414959448.webm	ba5e41c4-8085-4d08-a656-faca201d6ba3	ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-2
d08c0cc4-9f3d-4d75-be7b-a06c99c5b39c	153	2025-05-28 06:49:19.749459	3	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-2_1748414959330.webm	ba5e41c4-8085-4d08-a656-faca201d6ba3	ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-2
315c3a8b-417f-4c9c-98d9-2bdc97e6c369	153	2025-05-28 06:49:20.735005	5	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-2_1748414960506.webm	ba5e41c4-8085-4d08-a656-faca201d6ba3	ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-2
ecf0c810-0ca1-4b84-8a8c-541e54622151	153	2025-05-28 06:49:20.800165	6	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-2_1748414960555.webm	ba5e41c4-8085-4d08-a656-faca201d6ba3	ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-2
7869a2ad-8a2f-4ad0-94f3-cdda3c952ff1	154	2025-06-01 09:08:15.124224	1	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-1_1748768888327.webm	ba5e41c4-8085-4d08-a656-faca201d6ba3	ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-1
3551d5c5-538b-4bba-952e-a1666d8cbc6c	154	2025-06-01 09:08:16.262684	2	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-1_1748768890541.webm	ba5e41c4-8085-4d08-a656-faca201d6ba3	ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-1
1cc8df58-8abf-4737-ad10-e7ccb6b1e94a	154	2025-06-01 09:08:33.471639	3	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-1_1748768912949.webm	ba5e41c4-8085-4d08-a656-faca201d6ba3	ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-1
0d294fda-6413-4027-93d3-bf2600804dd6	154	2025-06-01 09:08:35.13203	4	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-1_1748768914717.webm	ba5e41c4-8085-4d08-a656-faca201d6ba3	ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-1
8f9fe4f0-b391-47f3-843b-23c6cec87861	154	2025-06-01 09:08:46.835402	5	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-1_1748768926232.webm	ba5e41c4-8085-4d08-a656-faca201d6ba3	ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-1
4282e098-a2a9-48c0-9ed9-276d7df9aacf	154	2025-06-01 09:08:47.30191	6	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-1_1748768926842.webm	ba5e41c4-8085-4d08-a656-faca201d6ba3	ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-1
c98af2fe-e4e1-496d-8015-65d340bcf874	154	2025-06-01 09:08:47.30191	6	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-1_1748768926712.webm	ba5e41c4-8085-4d08-a656-faca201d6ba3	ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-1
d0bd6249-e56a-4bd1-8a42-3824d96024f2	154	2025-06-01 09:08:47.292519	6	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-1_1748768926702.webm	ba5e41c4-8085-4d08-a656-faca201d6ba3	ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-1
168d3053-b979-409a-88e6-7f04b6e4b64c	154	2025-06-01 09:09:31.924228	9	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-1_1748768971283.webm	ba5e41c4-8085-4d08-a656-faca201d6ba3	ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-1
e96e0262-0c7c-4692-a4a2-ba2d4d1b27bf	154	2025-06-01 09:09:32.641978	10	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-1_1748768972207.webm	ba5e41c4-8085-4d08-a656-faca201d6ba3	ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-1
b50f4bd5-83f5-4911-8c80-e915af5dc627	154	2025-06-01 09:09:34.000013	11	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-1_1748768973616.webm	ba5e41c4-8085-4d08-a656-faca201d6ba3	ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-1
67b0dfe3-90ed-40f2-adf2-80f71a77d0be	154	2025-06-01 09:09:35.882048	12	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-1_1748768975219.webm	ba5e41c4-8085-4d08-a656-faca201d6ba3	ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-1
b95d4676-1559-431f-9080-f173978d9a73	155	2025-06-01 09:09:58.99215	1	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-2_1748768998220.webm	ba5e41c4-8085-4d08-a656-faca201d6ba3	ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-2
b474f1d0-6993-47a0-8edc-f9a0ab328d54	155	2025-06-01 09:10:01.829808	2	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-2_1748769001193.webm	ba5e41c4-8085-4d08-a656-faca201d6ba3	ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-2
0e47910c-a817-48fb-afc4-5a4b8e27f15b	155	2025-06-01 09:10:26.797709	3	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-2_1748769005321.webm	ba5e41c4-8085-4d08-a656-faca201d6ba3	ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-2
61dcc1e3-24cc-410d-8f9a-e7090d416cc0	155	2025-06-01 09:10:26.847431	3	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-2_1748769005468.webm	ba5e41c4-8085-4d08-a656-faca201d6ba3	ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-2
c7c0691a-0e3e-4b9f-8589-9f9796277465	156	2025-06-01 09:11:48.998418	1	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-3_1748769107207.webm	ba5e41c4-8085-4d08-a656-faca201d6ba3	ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-3
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."user" (id, created_at, name, improve_model) FROM stdin;
ba5e41c4-8085-4d08-a656-faca201d6ba3	2025-05-23 13:05:18.052165+00	testing	t
fb6b83d8-1528-440a-851a-2ef159b28b65	2025-05-27 05:20:12.89625+00	Teo Shi Yang	t
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2025-05-15 07:21:39
20211116045059	2025-05-15 07:21:39
20211116050929	2025-05-15 07:21:39
20211116051442	2025-05-15 07:21:39
20211116212300	2025-05-15 07:21:39
20211116213355	2025-05-15 07:21:39
20211116213934	2025-05-15 07:21:39
20211116214523	2025-05-15 07:21:39
20211122062447	2025-05-15 07:21:39
20211124070109	2025-05-15 07:21:39
20211202204204	2025-05-15 07:21:39
20211202204605	2025-05-15 07:21:39
20211210212804	2025-05-15 07:21:39
20211228014915	2025-05-15 07:21:39
20220107221237	2025-05-15 07:21:39
20220228202821	2025-05-15 07:21:39
20220312004840	2025-05-15 07:21:39
20220603231003	2025-05-15 07:21:39
20220603232444	2025-05-15 07:21:39
20220615214548	2025-05-15 07:21:39
20220712093339	2025-05-15 07:21:39
20220908172859	2025-05-15 07:21:39
20220916233421	2025-05-15 07:21:39
20230119133233	2025-05-15 07:21:39
20230128025114	2025-05-15 07:21:39
20230128025212	2025-05-15 07:21:39
20230227211149	2025-05-15 07:21:39
20230228184745	2025-05-15 07:21:39
20230308225145	2025-05-15 07:21:39
20230328144023	2025-05-15 07:21:39
20231018144023	2025-05-15 07:21:39
20231204144023	2025-05-15 07:21:39
20231204144024	2025-05-15 07:21:39
20231204144025	2025-05-15 07:21:39
20240108234812	2025-05-15 07:21:39
20240109165339	2025-05-15 07:21:39
20240227174441	2025-05-15 07:21:39
20240311171622	2025-05-15 07:21:39
20240321100241	2025-05-15 07:21:39
20240401105812	2025-05-15 07:21:39
20240418121054	2025-05-15 07:21:39
20240523004032	2025-05-15 07:21:39
20240618124746	2025-05-15 07:21:39
20240801235015	2025-05-15 07:21:39
20240805133720	2025-05-15 07:21:39
20240827160934	2025-05-15 07:21:39
20240919163303	2025-05-15 07:21:39
20240919163305	2025-05-15 07:21:39
20241019105805	2025-05-15 07:21:39
20241030150047	2025-05-15 07:21:39
20241108114728	2025-05-15 07:21:39
20241121104152	2025-05-15 07:21:39
20241130184212	2025-05-15 07:21:39
20241220035512	2025-05-15 07:21:39
20241220123912	2025-05-15 07:21:39
20241224161212	2025-05-15 07:21:40
20250107150512	2025-05-15 07:21:40
20250110162412	2025-05-15 07:21:40
20250123174212	2025-05-15 07:21:40
20250128220012	2025-05-15 07:21:40
20250506224012	2025-05-22 04:13:07
20250523164012	2025-06-02 14:41:29
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at) FROM stdin;
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id) FROM stdin;
video-chunks	video-chunks	\N	2025-05-23 11:29:44.139157+00	2025-05-23 11:29:44.139157+00	f	f	\N	\N	\N
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2025-05-15 07:20:28.551413
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2025-05-15 07:20:28.560687
2	storage-schema	5c7968fd083fcea04050c1b7f6253c9771b99011	2025-05-15 07:20:28.563506
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2025-05-15 07:20:28.584897
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2025-05-15 07:20:28.607465
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2025-05-15 07:20:28.61029
6	change-column-name-in-get-size	f93f62afdf6613ee5e7e815b30d02dc990201044	2025-05-15 07:20:28.614235
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2025-05-15 07:20:28.618132
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2025-05-15 07:20:28.630206
9	fix-search-function	3a0af29f42e35a4d101c259ed955b67e1bee6825	2025-05-15 07:20:28.633161
10	search-files-search-function	68dc14822daad0ffac3746a502234f486182ef6e	2025-05-15 07:20:28.63684
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2025-05-15 07:20:28.640706
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2025-05-15 07:20:28.644671
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2025-05-15 07:20:28.648093
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2025-05-15 07:20:28.651237
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2025-05-15 07:20:28.686212
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2025-05-15 07:20:28.689727
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2025-05-15 07:20:28.693484
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2025-05-15 07:20:28.69781
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2025-05-15 07:20:28.703209
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2025-05-15 07:20:28.708021
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2025-05-15 07:20:28.718465
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2025-05-15 07:20:28.750392
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2025-05-15 07:20:28.776938
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2025-05-15 07:20:28.780328
25	custom-metadata	d974c6057c3db1c1f847afa0e291e6165693b990	2025-05-15 07:20:28.783414
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata) FROM stdin;
0bae421e-1c4c-4206-b2e4-751b0f684d9c	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-8_1748336650712.webm	\N	2025-05-27 09:04:10.944473+00	2025-05-27 09:04:10.944473+00	2025-05-27 09:04:10.944473+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:04:11.000Z", "contentLength": 0, "httpStatusCode": 200}	2e58fcab-35cd-4132-8623-578b48a68fa3	\N	{}
00cca39a-c5a5-4ab8-87f7-9c5685b2efba	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--123-1_1748393943995.webm	\N	2025-05-28 00:59:05.308579+00	2025-05-28 00:59:05.308579+00	2025-05-28 00:59:05.308579+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T00:59:06.000Z", "contentLength": 0, "httpStatusCode": 200}	5af067f3-ec51-499d-9fc5-806fe3e9c6c1	\N	{}
5292714b-875b-4f8b-8162-7fdbcad4e619	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--333-2_1748334405173.webm	\N	2025-05-27 08:26:45.491899+00	2025-05-27 08:26:45.491899+00	2025-05-27 08:26:45.491899+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T08:26:46.000Z", "contentLength": 0, "httpStatusCode": 200}	ef5acebb-5e7a-4996-abb8-42d92b7f71b9	\N	{}
ce155007-ac3c-418b-9fa4-4000466871d9	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--333-2_1748334405951.webm	\N	2025-05-27 08:26:46.227466+00	2025-05-27 08:26:46.227466+00	2025-05-27 08:26:46.227466+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T08:26:47.000Z", "contentLength": 0, "httpStatusCode": 200}	db60b083-f3ab-41b2-b425-54774c0e1243	\N	{}
6613c0c4-5619-40bf-88ac-bc941b28d05f	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--333-3_1748334540084.webm	\N	2025-05-27 08:29:00.468781+00	2025-05-27 08:29:00.468781+00	2025-05-27 08:29:00.468781+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T08:29:01.000Z", "contentLength": 0, "httpStatusCode": 200}	4ad60461-8bea-46a6-b1db-380e3bbc8846	\N	{}
4f27671c-97bd-4195-92cc-675dafe75abf	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--333-3_1748334544972.webm	\N	2025-05-27 08:29:05.290552+00	2025-05-27 08:29:05.290552+00	2025-05-27 08:29:05.290552+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T08:29:06.000Z", "contentLength": 0, "httpStatusCode": 200}	0948f676-56a3-4293-88d2-f82f041a237e	\N	{}
e29b55f9-a5c0-4bb6-9dec-81c081880cd7	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--333-3_1748334551147.webm	\N	2025-05-27 08:29:11.463707+00	2025-05-27 08:29:11.463707+00	2025-05-27 08:29:11.463707+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T08:29:12.000Z", "contentLength": 0, "httpStatusCode": 200}	7f94bee9-9f06-4178-a3c0-04bd7f6e5258	\N	{}
702bc92d-e7dd-4895-9370-295f9a1607b7	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--000-1_1748336087001.webm	\N	2025-05-27 08:54:47.896098+00	2025-05-27 08:54:47.896098+00	2025-05-27 08:54:47.896098+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T08:54:48.000Z", "contentLength": 0, "httpStatusCode": 200}	922967b7-c85b-4fdb-8880-2a2ff28d5549	\N	{}
699c694a-f8d9-4c35-8c62-08f12c7f6334	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--000-1_1748336086994.webm	\N	2025-05-27 08:54:47.914911+00	2025-05-27 08:54:47.914911+00	2025-05-27 08:54:47.914911+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T08:54:48.000Z", "contentLength": 0, "httpStatusCode": 200}	accb9c92-3af4-4ef8-a151-00364f7da462	\N	{}
55604862-b730-4229-a982-12c2f12f6a7e	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-6_1748336398910.webm	\N	2025-05-27 08:59:59.343604+00	2025-05-27 08:59:59.343604+00	2025-05-27 08:59:59.343604+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:00:00.000Z", "contentLength": 0, "httpStatusCode": 200}	cd05bf9f-61d8-4cb7-9d01-3a167b1197a7	\N	{}
35591c55-48c8-412c-8b1e-fd29ec3dd6e6	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-6_1748336398912.webm	\N	2025-05-27 09:00:00.291902+00	2025-05-27 09:00:00.291902+00	2025-05-27 09:00:00.291902+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:00:01.000Z", "contentLength": 0, "httpStatusCode": 200}	23be5ae3-50a9-4a99-afca-745e24cf9605	\N	{}
6f95232b-e871-4c58-a49e-727156a2c0eb	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-7_1748336591868.webm	\N	2025-05-27 09:03:12.190131+00	2025-05-27 09:03:12.190131+00	2025-05-27 09:03:12.190131+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:03:13.000Z", "contentLength": 0, "httpStatusCode": 200}	760bfc3b-0b97-470e-b195-4ec8af6ed97a	\N	{}
d677b573-126b-4ce0-ab20-6ff72ddd6273	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-7_1748336591872.webm	\N	2025-05-27 09:03:12.34699+00	2025-05-27 09:03:12.34699+00	2025-05-27 09:03:12.34699+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:03:13.000Z", "contentLength": 0, "httpStatusCode": 200}	76a56f92-ccb9-4b71-999b-775aab79526b	\N	{}
6a83475a-8af4-478a-8f78-42d8fabc26a8	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-7_1748336592740.webm	\N	2025-05-27 09:03:12.917301+00	2025-05-27 09:03:12.917301+00	2025-05-27 09:03:12.917301+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:03:13.000Z", "contentLength": 0, "httpStatusCode": 200}	ab4ddc49-4766-4b0c-a505-b52fa2fdfe00	\N	{}
93318f95-3d42-4c9f-86ed-29df33622b7d	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-8_1748336651429.webm	\N	2025-05-27 09:04:11.682087+00	2025-05-27 09:04:11.682087+00	2025-05-27 09:04:11.682087+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:04:12.000Z", "contentLength": 0, "httpStatusCode": 200}	50e2c3c3-a181-48c9-9a95-857b99dd975e	\N	{}
540cebf8-469f-403f-8b55-18ad3454a723	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-7_1748336593319.webm	\N	2025-05-27 09:03:13.505348+00	2025-05-27 09:03:13.505348+00	2025-05-27 09:03:13.505348+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:03:14.000Z", "contentLength": 0, "httpStatusCode": 200}	5bfe6d82-8510-4a2c-831a-e5ceb8719af0	\N	{}
df2d3ec1-f222-426a-85b9-eeaa79920872	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-8_1748336651512.webm	\N	2025-05-27 09:04:11.739331+00	2025-05-27 09:04:11.739331+00	2025-05-27 09:04:11.739331+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:04:12.000Z", "contentLength": 0, "httpStatusCode": 200}	c95a5767-5283-41dd-a1dd-f207a363228c	\N	{}
4612964e-1571-43c3-a81f-cfa3ebbe8b9d	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-7_1748336594131.webm	\N	2025-05-27 09:03:14.430489+00	2025-05-27 09:03:14.430489+00	2025-05-27 09:03:14.430489+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:03:15.000Z", "contentLength": 0, "httpStatusCode": 200}	f941ae1f-071d-40a4-9ea5-60e26fac79b6	\N	{}
b77d3444-167e-4267-a570-a069e36127f2	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-10_1748352261524.webm	\N	2025-05-27 13:24:21.948574+00	2025-05-27 13:24:21.948574+00	2025-05-27 13:24:21.948574+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:24:22.000Z", "contentLength": 0, "httpStatusCode": 200}	0f729b0d-de99-4bb2-aef0-71bc027d71b8	\N	{}
5c5501ab-22c0-4f86-8e77-5fea6c769558	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-7_1748336598157.webm	\N	2025-05-27 09:03:18.505932+00	2025-05-27 09:03:18.505932+00	2025-05-27 09:03:18.505932+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:03:19.000Z", "contentLength": 0, "httpStatusCode": 200}	cf90dc1b-b811-4736-b02a-0b88360f68d9	\N	{}
8685020e-881a-49f4-a91e-1463f5822546	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-8_1748336651685.webm	\N	2025-05-27 09:04:11.898178+00	2025-05-27 09:04:11.898178+00	2025-05-27 09:04:11.898178+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:04:12.000Z", "contentLength": 0, "httpStatusCode": 200}	2fe44902-3329-425d-aa2e-6d99d17be759	\N	{}
4b24dc93-9378-4626-aee5-e32a2475be55	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-7_1748336598763.webm	\N	2025-05-27 09:03:19.013244+00	2025-05-27 09:03:19.013244+00	2025-05-27 09:03:19.013244+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:03:20.000Z", "contentLength": 0, "httpStatusCode": 200}	3be0d014-ae8c-4abc-910b-73941fc21bdf	\N	{}
e5ed2ba5-7e82-4322-8dec-b773c1ade4ca	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--234-1_1748336708511.webm	\N	2025-05-27 09:05:10.558885+00	2025-05-27 09:05:10.558885+00	2025-05-27 09:05:10.558885+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:05:11.000Z", "contentLength": 0, "httpStatusCode": 200}	c5f0f8b0-6586-44d9-9765-7f692411bed5	\N	{}
9c08eff8-1cd1-41a6-9d88-e5dd64a49115	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-7_1748336599721.webm	\N	2025-05-27 09:03:19.98851+00	2025-05-27 09:03:19.98851+00	2025-05-27 09:03:19.98851+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:03:20.000Z", "contentLength": 0, "httpStatusCode": 200}	3e9216ee-5b1d-4bb6-bacf-dbc482953207	\N	{}
b69519c1-a8d5-42ae-a0a9-24bdba758d52	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-7_1748336599718.webm	\N	2025-05-27 09:03:20.013527+00	2025-05-27 09:03:20.013527+00	2025-05-27 09:03:20.013527+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:03:21.000Z", "contentLength": 0, "httpStatusCode": 200}	a08d4a2d-cedc-44af-ab2a-4f36c3e999e6	\N	{}
c434dcca-0bd5-4661-9e4a-3cd1976a8521	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-7_1748336600165.webm	\N	2025-05-27 09:03:20.45881+00	2025-05-27 09:03:20.45881+00	2025-05-27 09:03:20.45881+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:03:21.000Z", "contentLength": 0, "httpStatusCode": 200}	27eddc4b-3772-4fb4-b141-f433793b96ab	\N	{}
1fc004f0-46e2-401b-bece-7d512682ecb2	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-7_1748336600163.webm	\N	2025-05-27 09:03:20.457358+00	2025-05-27 09:03:20.457358+00	2025-05-27 09:03:20.457358+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:03:21.000Z", "contentLength": 0, "httpStatusCode": 200}	db90ced7-88b9-4e8b-8443-bca9546543d3	\N	{}
a6882dcc-e248-4f5e-a633-d251813c0622	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-7_1748336601357.webm	\N	2025-05-27 09:03:21.574101+00	2025-05-27 09:03:21.574101+00	2025-05-27 09:03:21.574101+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:03:22.000Z", "contentLength": 0, "httpStatusCode": 200}	28203fc6-04ad-4f9c-910c-37211264b0c3	\N	{}
a050737c-66ac-49f5-b9f5-630e0ee3d32b	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-7_1748336601964.webm	\N	2025-05-27 09:03:22.211028+00	2025-05-27 09:03:22.211028+00	2025-05-27 09:03:22.211028+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:03:23.000Z", "contentLength": 0, "httpStatusCode": 200}	7b7b07db-09ca-45d0-85a6-0a26c8974f8c	\N	{}
eea3bcca-4ab8-4663-b75d-7d68a46a64ed	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-10_1748352261519.webm	\N	2025-05-27 13:24:21.994067+00	2025-05-27 13:24:21.994067+00	2025-05-27 13:24:21.994067+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:24:22.000Z", "contentLength": 0, "httpStatusCode": 200}	47f7da59-f497-4a24-b17a-9dfe245049df	\N	{}
5159ee9f-f3c7-44dd-8117-92642e3916db	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-7_1748336603520.webm	\N	2025-05-27 09:03:23.740193+00	2025-05-27 09:03:23.740193+00	2025-05-27 09:03:23.740193+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:03:24.000Z", "contentLength": 0, "httpStatusCode": 200}	29e9892e-8ef7-4aae-8331-faa7901c0a0a	\N	{}
1f1251d2-de4f-4ee2-b487-074506ad083a	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--234-1_1748336710055.webm	\N	2025-05-27 09:05:11.3119+00	2025-05-27 09:05:11.3119+00	2025-05-27 09:05:11.3119+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:05:12.000Z", "contentLength": 0, "httpStatusCode": 200}	9b5eb8e2-a0fa-47a8-a44f-63122965ca3a	\N	{}
69e1e274-924e-457d-9b64-2a0ccadd37e1	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-7_1748336603902.webm	\N	2025-05-27 09:03:24.104979+00	2025-05-27 09:03:24.104979+00	2025-05-27 09:03:24.104979+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:03:25.000Z", "contentLength": 0, "httpStatusCode": 200}	b5458333-18d6-4968-a2ed-97701e4dca2a	\N	{}
6493fff2-1dc6-42ee-8d9e-24c8dbee9f96	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-8_1748336616467.webm	\N	2025-05-27 09:03:36.819937+00	2025-05-27 09:03:36.819937+00	2025-05-27 09:03:36.819937+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:03:37.000Z", "contentLength": 0, "httpStatusCode": 200}	d2a68003-b483-4e64-9485-f521b82eec66	\N	{}
0ce774e2-1cd6-400b-9616-967ed551760e	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-8_1748336616988.webm	\N	2025-05-27 09:03:37.240662+00	2025-05-27 09:03:37.240662+00	2025-05-27 09:03:37.240662+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:03:38.000Z", "contentLength": 0, "httpStatusCode": 200}	38121a9b-7ed6-4306-9c2b-35e989793360	\N	{}
d667fd1b-eded-4f2a-8041-23da46d7c560	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--5-1_1748336784658.webm	\N	2025-05-27 09:06:24.968872+00	2025-05-27 09:06:24.968872+00	2025-05-27 09:06:24.968872+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:06:25.000Z", "contentLength": 0, "httpStatusCode": 200}	b221c02d-a60c-4821-a4c2-f035c7168368	\N	{}
3ed1a3cf-50bb-4443-bf73-58bfd5dccbe8	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-8_1748336618553.webm	\N	2025-05-27 09:03:38.76804+00	2025-05-27 09:03:38.76804+00	2025-05-27 09:03:38.76804+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:03:39.000Z", "contentLength": 0, "httpStatusCode": 200}	beb3f2df-2bd2-4b8a-92e8-16dedf253da7	\N	{}
64604b1b-c120-4a54-a62a-9144ce12c6ae	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-8_1748336619111.webm	\N	2025-05-27 09:03:39.296288+00	2025-05-27 09:03:39.296288+00	2025-05-27 09:03:39.296288+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:03:40.000Z", "contentLength": 0, "httpStatusCode": 200}	59b1494f-2188-4e51-805d-cafb907d385f	\N	{}
420b5e24-ecb9-4b6e-8adb-6f95aa0af0d8	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--5-1_1748336790518.webm	\N	2025-05-27 09:06:30.861633+00	2025-05-27 09:06:30.861633+00	2025-05-27 09:06:30.861633+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:06:31.000Z", "contentLength": 0, "httpStatusCode": 200}	087a59ac-84d8-470e-afe4-f7227ef502f8	\N	{}
ee932772-6b92-401e-87f3-d1d2ec8d5eb7	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-8_1748336620959.webm	\N	2025-05-27 09:03:41.19067+00	2025-05-27 09:03:41.19067+00	2025-05-27 09:03:41.19067+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:03:42.000Z", "contentLength": 0, "httpStatusCode": 200}	4f87029b-c77d-4b55-b5de-0f178332c3c5	\N	{}
13e67251-ce48-4b91-bdf4-9b1209062756	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-8_1748336621529.webm	\N	2025-05-27 09:03:41.748134+00	2025-05-27 09:03:41.748134+00	2025-05-27 09:03:41.748134+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:03:42.000Z", "contentLength": 0, "httpStatusCode": 200}	dfcf9a4a-a7da-4087-b274-30c8b939324d	\N	{}
28f05ad5-b248-4f91-8778-115ce5c73617	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-8_1748336622295.webm	\N	2025-05-27 09:03:42.548451+00	2025-05-27 09:03:42.548451+00	2025-05-27 09:03:42.548451+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:03:43.000Z", "contentLength": 0, "httpStatusCode": 200}	7f42cef9-d819-4660-b25b-998fe553d266	\N	{}
94548304-03a0-4950-b25c-2e5a1147e49f	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-8_1748336623046.webm	\N	2025-05-27 09:03:43.251534+00	2025-05-27 09:03:43.251534+00	2025-05-27 09:03:43.251534+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:03:44.000Z", "contentLength": 0, "httpStatusCode": 200}	71981275-e36a-4a01-8a5d-1db41f25cc5f	\N	{}
0e902a9b-9614-47ad-8e5c-92157e7e14d2	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-10_1748352265995.webm	\N	2025-05-27 13:24:26.325094+00	2025-05-27 13:24:26.325094+00	2025-05-27 13:24:26.325094+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:24:27.000Z", "contentLength": 0, "httpStatusCode": 200}	bb60e1e1-c5f8-441b-a572-68f849089abd	\N	{}
e850d150-c2e2-4a00-aeb8-98a4be45d085	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--5-1_1748336792111.webm	\N	2025-05-27 09:06:32.352129+00	2025-05-27 09:06:32.352129+00	2025-05-27 09:06:32.352129+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:06:33.000Z", "contentLength": 0, "httpStatusCode": 200}	210b8b20-a23c-4675-84d1-683b57131923	\N	{}
ddc4e8e9-d890-4451-833a-16458ac23c3b	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-8_1748336625288.webm	\N	2025-05-27 09:03:45.545427+00	2025-05-27 09:03:45.545427+00	2025-05-27 09:03:45.545427+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:03:46.000Z", "contentLength": 0, "httpStatusCode": 200}	c2c6d8f1-620d-4c31-8d83-d12ede7fe246	\N	{}
a3af327e-13ef-4285-9235-55cbbe2d9ff2	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-8_1748336625388.webm	\N	2025-05-27 09:03:45.572923+00	2025-05-27 09:03:45.572923+00	2025-05-27 09:03:45.572923+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:03:46.000Z", "contentLength": 0, "httpStatusCode": 200}	9a05a332-c2fb-4280-aa66-65aa0cf1278f	\N	{}
50ff5498-5e52-42ba-a96a-bd2e6d3401e4	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--123-1_1748393943913.webm	\N	2025-05-28 00:59:05.303743+00	2025-05-28 00:59:05.303743+00	2025-05-28 00:59:05.303743+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T00:59:06.000Z", "contentLength": 0, "httpStatusCode": 200}	1a6d3a4c-4f6d-4855-b27b-aca1495cdc95	\N	{}
e7820856-9a56-4344-b63c-16a749a65b79	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-8_1748336626489.webm	\N	2025-05-27 09:03:46.701825+00	2025-05-27 09:03:46.701825+00	2025-05-27 09:03:46.701825+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:03:47.000Z", "contentLength": 0, "httpStatusCode": 200}	fb47ee75-3719-4158-acb6-e18d219303df	\N	{}
4bb0201e-057b-4337-b0d8-e7c4f8252a5d	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--5-1_1748336792212.webm	\N	2025-05-27 09:06:32.46428+00	2025-05-27 09:06:32.46428+00	2025-05-27 09:06:32.46428+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:06:33.000Z", "contentLength": 0, "httpStatusCode": 200}	d8742326-7adb-4a8c-8c26-4f74a2ac0ba8	\N	{}
7b52335f-7803-4d98-bf08-b840c6620d27	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-8_1748336626793.webm	\N	2025-05-27 09:03:47.008262+00	2025-05-27 09:03:47.008262+00	2025-05-27 09:03:47.008262+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:03:48.000Z", "contentLength": 0, "httpStatusCode": 200}	3ea7ca05-f096-4ae8-8744-f66e6d22c6ed	\N	{}
7e142445-d173-4cf4-8063-94937e06ab82	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-8_1748336628819.webm	\N	2025-05-27 09:03:49.05139+00	2025-05-27 09:03:49.05139+00	2025-05-27 09:03:49.05139+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:03:50.000Z", "contentLength": 0, "httpStatusCode": 200}	e34808e8-6968-4f59-91cd-6db4e5e619d8	\N	{}
a5de3310-b27f-4768-9917-f63972aff5ca	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-8_1748336631230.webm	\N	2025-05-27 09:03:51.443741+00	2025-05-27 09:03:51.443741+00	2025-05-27 09:03:51.443741+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:03:52.000Z", "contentLength": 0, "httpStatusCode": 200}	651579f3-cdf0-4cf2-a689-f546ed01f8a6	\N	{}
184d8373-073a-4bb8-b0c6-43c81e06089b	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--45-1_1748336953484.webm	\N	2025-05-27 09:09:14.510156+00	2025-05-27 09:09:14.510156+00	2025-05-27 09:09:14.510156+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:09:15.000Z", "contentLength": 0, "httpStatusCode": 200}	55a45241-ea4f-4900-bbb3-f9ab5d82a205	\N	{}
dfbc5f50-3528-4eb1-b7bd-7473f8aa2f5a	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-8_1748336631864.webm	\N	2025-05-27 09:03:52.077657+00	2025-05-27 09:03:52.077657+00	2025-05-27 09:03:52.077657+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:03:53.000Z", "contentLength": 0, "httpStatusCode": 200}	85bd4b72-4c8d-40b8-8437-c69414635ced	\N	{}
a9ac8541-ce32-4acf-b4e4-9b4789520c27	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-8_1748336632142.webm	\N	2025-05-27 09:03:52.334441+00	2025-05-27 09:03:52.334441+00	2025-05-27 09:03:52.334441+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:03:53.000Z", "contentLength": 0, "httpStatusCode": 200}	11ad1dcb-cdf3-4ec1-b00a-494e5b523563	\N	{}
253a2fa5-59f1-48d9-ba21-251e9215ba3c	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-8_1748336632958.webm	\N	2025-05-27 09:03:53.187105+00	2025-05-27 09:03:53.187105+00	2025-05-27 09:03:53.187105+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:03:54.000Z", "contentLength": 0, "httpStatusCode": 200}	a4022a8b-f152-4b34-bd3c-d0844abe3613	\N	{}
5a32aea2-f42b-4555-a327-d9d05a2d323b	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-8_1748336633490.webm	\N	2025-05-27 09:03:53.71775+00	2025-05-27 09:03:53.71775+00	2025-05-27 09:03:53.71775+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:03:54.000Z", "contentLength": 0, "httpStatusCode": 200}	2f312651-4d77-4440-b5c0-52873f1b22bb	\N	{}
615748a8-95ca-4603-978a-27f4cc700cd6	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--45-1_1748336953489.webm	\N	2025-05-27 09:09:14.536958+00	2025-05-27 09:09:14.536958+00	2025-05-27 09:09:14.536958+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:09:15.000Z", "contentLength": 0, "httpStatusCode": 200}	5ae6dede-e385-4955-a859-b7ca08bda393	\N	{}
9adb21cf-f661-4354-b068-b76ff859b80a	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-8_1748336634780.webm	\N	2025-05-27 09:03:54.999308+00	2025-05-27 09:03:54.999308+00	2025-05-27 09:03:54.999308+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:03:56.000Z", "contentLength": 0, "httpStatusCode": 200}	12cb017c-3c7e-4198-9245-bb9a19a3ff29	\N	{}
ed49bf02-0f1b-482a-ab94-1514b6eaddad	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-10_1748352266354.webm	\N	2025-05-27 13:24:26.606789+00	2025-05-27 13:24:26.606789+00	2025-05-27 13:24:26.606789+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:24:27.000Z", "contentLength": 0, "httpStatusCode": 200}	62c1fb93-b1dc-4312-b24e-808f2b76aa19	\N	{}
1b212e11-fc9b-4229-9b6e-073f544c9f66	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-8_1748336635653.webm	\N	2025-05-27 09:03:55.90301+00	2025-05-27 09:03:55.90301+00	2025-05-27 09:03:55.90301+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:03:56.000Z", "contentLength": 0, "httpStatusCode": 200}	370617a9-1f05-4502-bb48-73281ade345f	\N	{}
c6f11613-5579-4195-b0f3-4ae5458f4024	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--345-1_1748337062343.webm	\N	2025-05-27 09:11:02.824829+00	2025-05-27 09:11:02.824829+00	2025-05-27 09:11:02.824829+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:11:03.000Z", "contentLength": 0, "httpStatusCode": 200}	00861547-e35e-406d-b7f0-cd731100fa90	\N	{}
ae4ec23e-7af1-4513-8209-3f57bdad4486	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--123-1_1748393943903.webm	\N	2025-05-28 00:59:05.326026+00	2025-05-28 00:59:05.326026+00	2025-05-28 00:59:05.326026+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T00:59:06.000Z", "contentLength": 0, "httpStatusCode": 200}	c95bcbd7-dc9f-4ccd-80de-c4a10e15ef66	\N	{}
466c94c8-d3ea-443f-8ba7-1f07e9c043d4	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-8_1748336637127.webm	\N	2025-05-27 09:03:57.373379+00	2025-05-27 09:03:57.373379+00	2025-05-27 09:03:57.373379+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:03:58.000Z", "contentLength": 0, "httpStatusCode": 200}	725599fa-8069-4dd6-bd06-fd2757b6087c	\N	{}
2978934b-4680-4385-aa14-a50babcd776d	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-8_1748336637130.webm	\N	2025-05-27 09:03:57.409352+00	2025-05-27 09:03:57.409352+00	2025-05-27 09:03:57.409352+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:03:58.000Z", "contentLength": 0, "httpStatusCode": 200}	45f3ad90-dc63-4475-89aa-af7c7fd87089	\N	{}
510dd6aa-df6b-4990-80eb-880da5ac1bca	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--345-1_1748337063837.webm	\N	2025-05-27 09:11:04.101594+00	2025-05-27 09:11:04.101594+00	2025-05-27 09:11:04.101594+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:11:05.000Z", "contentLength": 0, "httpStatusCode": 200}	310d37e7-c0c7-4d3c-bacb-aa304e807979	\N	{}
dae195fa-ffcc-4e35-8a86-c3c33e0e1279	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-8_1748336637565.webm	\N	2025-05-27 09:03:57.742654+00	2025-05-27 09:03:57.742654+00	2025-05-27 09:03:57.742654+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:03:58.000Z", "contentLength": 0, "httpStatusCode": 200}	6e09fb55-48f3-4d9c-99b1-7ea009107be9	\N	{}
1fe7224c-b040-421e-9629-d8b389dbeca8	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--345667-1_1748338048064.webm	\N	2025-05-27 09:27:28.310126+00	2025-05-27 09:27:28.310126+00	2025-05-27 09:27:28.310126+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:27:29.000Z", "contentLength": 0, "httpStatusCode": 200}	21e71b29-59a3-408a-a6da-940c4a307a24	\N	{}
cb3e826b-1ced-46f4-99e1-efa0253388bf	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-8_1748336638699.webm	\N	2025-05-27 09:03:58.904933+00	2025-05-27 09:03:58.904933+00	2025-05-27 09:03:58.904933+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:03:59.000Z", "contentLength": 0, "httpStatusCode": 200}	c051543f-a034-442b-813a-a000b1aac59a	\N	{}
9777c915-308e-4774-a4c8-84de862b08fa	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-8_1748336640922.webm	\N	2025-05-27 09:04:01.124374+00	2025-05-27 09:04:01.124374+00	2025-05-27 09:04:01.124374+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:04:02.000Z", "contentLength": 0, "httpStatusCode": 200}	2ad1508c-f296-412d-88c8-0a7703320f32	\N	{}
f34d7aca-b50f-483a-b603-7c6e0393c4c7	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-8_1748336642940.webm	\N	2025-05-27 09:04:03.174266+00	2025-05-27 09:04:03.174266+00	2025-05-27 09:04:03.174266+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:04:04.000Z", "contentLength": 0, "httpStatusCode": 200}	c2ca9754-89d4-416f-8f1b-b10e691ad427	\N	{}
22d43208-cbc5-47a9-a809-21a356dd6320	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-8_1748336644065.webm	\N	2025-05-27 09:04:04.356528+00	2025-05-27 09:04:04.356528+00	2025-05-27 09:04:04.356528+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:04:05.000Z", "contentLength": 0, "httpStatusCode": 200}	11c853d7-7d20-452f-b219-8ed00e903429	\N	{}
b6413f6d-94e5-4295-a0f6-2a96b324e5cc	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-8_1748336645310.webm	\N	2025-05-27 09:04:05.553951+00	2025-05-27 09:04:05.553951+00	2025-05-27 09:04:05.553951+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:04:06.000Z", "contentLength": 0, "httpStatusCode": 200}	e0f55c26-abd5-46e3-9319-97c9a0a817aa	\N	{}
0cc1eeb4-5e7e-4399-a8e9-b9a3ec81e02c	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-10_1748352266917.webm	\N	2025-05-27 13:24:27.239229+00	2025-05-27 13:24:27.239229+00	2025-05-27 13:24:27.239229+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:24:28.000Z", "contentLength": 0, "httpStatusCode": 200}	03fe0671-1a9a-4fb0-ad48-d6dfe9d376aa	\N	{}
e0bee5d9-6ea0-43b3-8deb-4ded64cfe789	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-8_1748336648199.webm	\N	2025-05-27 09:04:08.456838+00	2025-05-27 09:04:08.456838+00	2025-05-27 09:04:08.456838+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:04:09.000Z", "contentLength": 0, "httpStatusCode": 200}	cc92ad0a-cf0a-43d7-a400-4247004512bb	\N	{}
718ed3c4-508e-4afc-b7f8-d8aba3593741	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--345-2_1748337673574.webm	\N	2025-05-27 09:21:13.941176+00	2025-05-27 09:21:13.941176+00	2025-05-27 09:21:13.941176+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:21:14.000Z", "contentLength": 0, "httpStatusCode": 200}	093b1fbb-497e-46a5-bf5a-17fa04a51576	\N	{}
1d0bef75-9aad-4830-811c-30d2590583ee	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--345-2_1748337688853.webm	\N	2025-05-27 09:21:29.194354+00	2025-05-27 09:21:29.194354+00	2025-05-27 09:21:29.194354+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:21:30.000Z", "contentLength": 0, "httpStatusCode": 200}	be544c39-5f80-4114-941f-653a52a17cc5	\N	{}
203a94d7-472f-4827-99b4-ae2da8354ac8	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-10_1748352267942.webm	\N	2025-05-27 13:24:28.216522+00	2025-05-27 13:24:28.216522+00	2025-05-27 13:24:28.216522+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:24:29.000Z", "contentLength": 0, "httpStatusCode": 200}	8fc535bb-ef9d-4e36-95a6-a515ba63b053	\N	{}
b1e6afdd-48cb-4a29-ab3f-505c5768a2e6	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--555666-1_1748337757726.webm	\N	2025-05-27 09:22:38.043653+00	2025-05-27 09:22:38.043653+00	2025-05-27 09:22:38.043653+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:22:39.000Z", "contentLength": 0, "httpStatusCode": 200}	b4fab9cb-3c90-4f73-8570-b96b366e1d1f	\N	{}
d97bc71c-1521-4353-828a-30510743507d	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--123-2_1748394010680.webm	\N	2025-05-28 01:00:10.865855+00	2025-05-28 01:00:10.865855+00	2025-05-28 01:00:10.865855+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T01:00:11.000Z", "contentLength": 0, "httpStatusCode": 200}	7c2df496-b779-484f-a78b-cdc4a62f2c18	\N	{}
b6f494a3-62dd-44c6-b9c5-cccfbfd65fc6	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--555666-1_1748337758928.webm	\N	2025-05-27 09:22:39.185172+00	2025-05-27 09:22:39.185172+00	2025-05-27 09:22:39.185172+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:22:40.000Z", "contentLength": 0, "httpStatusCode": 200}	062b7d0e-0695-463e-8875-ff8b376f6e78	\N	{}
65a861bb-0275-403a-9827-b82a10e1b168	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-10_1748352268114.webm	\N	2025-05-27 13:24:28.357473+00	2025-05-27 13:24:28.357473+00	2025-05-27 13:24:28.357473+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:24:29.000Z", "contentLength": 0, "httpStatusCode": 200}	b0bb5dd9-f0a0-4932-9228-2eacc08131a5	\N	{}
afa54e13-e063-4414-8ae3-9b975e4288ff	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--111-1_1748337955843.webm	\N	2025-05-27 09:25:56.171347+00	2025-05-27 09:25:56.171347+00	2025-05-27 09:25:56.171347+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:25:57.000Z", "contentLength": 0, "httpStatusCode": 200}	b28856a3-8f01-47ed-96c8-b60a28ccc9f3	\N	{}
9bfdb9d5-3611-4df6-8c13-58946fa116b2	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--111-1_1748337956488.webm	\N	2025-05-27 09:25:56.729662+00	2025-05-27 09:25:56.729662+00	2025-05-27 09:25:56.729662+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:25:57.000Z", "contentLength": 0, "httpStatusCode": 200}	2942c5d3-64a5-48c9-9250-7796e0c5680b	\N	{}
cdc2b2b5-156d-436a-93f7-311db30a9bac	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--345667-1_1748338028319.webm	\N	2025-05-27 09:27:08.652642+00	2025-05-27 09:27:08.652642+00	2025-05-27 09:27:08.652642+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:27:09.000Z", "contentLength": 0, "httpStatusCode": 200}	d30d782d-bd0c-44e3-b200-db41cebae5b1	\N	{}
8d479156-f02c-4e4b-928e-27f9304bea55	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--345667-1_1748338047080.webm	\N	2025-05-27 09:27:27.936795+00	2025-05-27 09:27:27.936795+00	2025-05-27 09:27:27.936795+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:27:28.000Z", "contentLength": 0, "httpStatusCode": 200}	d800759a-6e94-466a-93a1-278b7a519c4f	\N	{}
4c67f9fd-6b5c-49b0-90ac-8706aee3804a	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-8_1748336649338.webm	\N	2025-05-27 09:04:09.572982+00	2025-05-27 09:04:09.572982+00	2025-05-27 09:04:09.572982+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:04:10.000Z", "contentLength": 0, "httpStatusCode": 200}	4f44ad9f-a431-4a98-b506-56a45bf59d7d	\N	{}
16f7bb66-7d7d-4b93-807e-3b3a86187602	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-8_1748336649335.webm	\N	2025-05-27 09:04:09.596071+00	2025-05-27 09:04:09.596071+00	2025-05-27 09:04:09.596071+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:04:10.000Z", "contentLength": 0, "httpStatusCode": 200}	3cca24fd-a0a1-4396-94f1-24cefd44f82c	\N	{}
cf5b7229-3d13-4dac-a68e-51d669a72c68	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-10_1748352268424.webm	\N	2025-05-27 13:24:28.745321+00	2025-05-27 13:24:28.745321+00	2025-05-27 13:24:28.745321+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:24:29.000Z", "contentLength": 0, "httpStatusCode": 200}	cd9d567d-ac23-49e4-a45d-882492b52150	\N	{}
f021c018-ce8d-40d8-b18b-16f3a298a5eb	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--345667-1_1748338047538.webm	\N	2025-05-27 09:27:27.797084+00	2025-05-27 09:27:27.797084+00	2025-05-27 09:27:27.797084+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:27:28.000Z", "contentLength": 0, "httpStatusCode": 200}	cb49fe39-6787-4bd2-99aa-80a49df9cd41	\N	{}
29431fa4-7907-4b98-b83c-6428673e391b	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-3_1748769107221.webm	\N	2025-06-01 09:11:47.467345+00	2025-06-01 09:11:47.467345+00	2025-06-01 09:11:47.467345+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-06-01T09:11:48.000Z", "contentLength": 0, "httpStatusCode": 200}	73665b39-f0cb-4dfd-8ac7-b0648034068f	\N	{}
96de902b-f4e1-47e6-8a97-d9312da63729	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--345667-1_1748338048112.webm	\N	2025-05-27 09:27:28.363243+00	2025-05-27 09:27:28.363243+00	2025-05-27 09:27:28.363243+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:27:29.000Z", "contentLength": 0, "httpStatusCode": 200}	6a6aec84-d49b-49e4-8c40-1ac5e2ccde9d	\N	{}
62507afe-e7b8-4c48-bb02-5e69d3f6d385	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--345667-1_1748338048102.webm	\N	2025-05-27 09:27:28.380824+00	2025-05-27 09:27:28.380824+00	2025-05-27 09:27:28.380824+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:27:29.000Z", "contentLength": 0, "httpStatusCode": 200}	eb0e134b-3588-4e1c-82d2-4be97683d8a4	\N	{}
37b9aed1-93ae-426d-9f44-162df7564858	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-10_1748352269485.webm	\N	2025-05-27 13:24:29.73044+00	2025-05-27 13:24:29.73044+00	2025-05-27 13:24:29.73044+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:24:30.000Z", "contentLength": 0, "httpStatusCode": 200}	fba0393f-005e-4633-9f8f-83779808c3ee	\N	{}
790ee3e5-80aa-4f36-88e2-868bdf38eadb	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--1-1_1748338198038.webm	\N	2025-05-27 09:29:58.646524+00	2025-05-27 09:29:58.646524+00	2025-05-27 09:29:58.646524+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:29:59.000Z", "contentLength": 0, "httpStatusCode": 200}	5694ce74-f8ba-4673-afac-ac78016eb0e7	\N	{}
d49d963f-9c36-47a0-b65b-004c31f46a7a	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--1-1_1748338212580.webm	\N	2025-05-27 09:30:12.924944+00	2025-05-27 09:30:12.924944+00	2025-05-27 09:30:12.924944+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:30:13.000Z", "contentLength": 0, "httpStatusCode": 200}	44ef2428-27d8-4594-8999-b600c8980e88	\N	{}
6229d358-1a45-4e2d-98cf-0177cd66486a	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-10_1748352269594.webm	\N	2025-05-27 13:24:29.905607+00	2025-05-27 13:24:29.905607+00	2025-05-27 13:24:29.905607+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:24:30.000Z", "contentLength": 0, "httpStatusCode": 200}	31c324cb-bfc1-432d-83a5-baf965f8cc45	\N	{}
82cb2a94-8c8f-4759-8f87-7996249a57b6	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--1-1_1748338213178.webm	\N	2025-05-27 09:30:13.469878+00	2025-05-27 09:30:13.469878+00	2025-05-27 09:30:13.469878+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:30:14.000Z", "contentLength": 0, "httpStatusCode": 200}	32d22c30-19ab-4700-b34b-0067705c5ecc	\N	{}
e8a79328-3d3b-4803-8b24-f7ae89078c28	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--1-1_1748338213568.webm	\N	2025-05-27 09:30:13.824664+00	2025-05-27 09:30:13.824664+00	2025-05-27 09:30:13.824664+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:30:14.000Z", "contentLength": 0, "httpStatusCode": 200}	392177de-657d-4cc3-a26d-aa70fd9a9725	\N	{}
064bdeff-5d7a-4343-a99a-150c85cd1ef5	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--1-1_1748338213713.webm	\N	2025-05-27 09:30:13.976935+00	2025-05-27 09:30:13.976935+00	2025-05-27 09:30:13.976935+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:30:14.000Z", "contentLength": 0, "httpStatusCode": 200}	31be024a-76ba-4a74-bfb5-fd06d5fb4ebf	\N	{}
a2ef96da-ee5c-4def-ac03-af539bda872a	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--555-1_1748338473792.webm	\N	2025-05-27 09:34:34.158197+00	2025-05-27 09:34:34.158197+00	2025-05-27 09:34:34.158197+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:34:35.000Z", "contentLength": 0, "httpStatusCode": 200}	72c6f000-b90b-4d83-9b8a-35a837c4cdda	\N	{}
62144bb1-26bb-4e49-b282-288e9a2c7246	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--555-1_1748338479100.webm	\N	2025-05-27 09:34:39.353802+00	2025-05-27 09:34:39.353802+00	2025-05-27 09:34:39.353802+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:34:40.000Z", "contentLength": 0, "httpStatusCode": 200}	ee14bb12-4145-4115-a1ee-ce13b61a3f59	\N	{}
e9eba568-f8a4-41ac-83a7-e8509e067b20	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--123-2_1748394013900.webm	\N	2025-05-28 01:00:13.89709+00	2025-05-28 01:00:13.89709+00	2025-05-28 01:00:13.89709+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T01:00:14.000Z", "contentLength": 0, "httpStatusCode": 200}	aeca9ff6-4871-49ca-a8f4-3abb2b1a90d1	\N	{}
476c018f-f3af-4cd5-a423-500e59a79b5a	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--555-1_1748338479417.webm	\N	2025-05-27 09:34:39.669751+00	2025-05-27 09:34:39.669751+00	2025-05-27 09:34:39.669751+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T09:34:40.000Z", "contentLength": 0, "httpStatusCode": 200}	bcd100c1-d65b-4b57-9de7-3bfb7bb88de6	\N	{}
1625e9db-dc8f-4320-8f9e-b68d40e40096	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-10_1748352269812.webm	\N	2025-05-27 13:24:30.352596+00	2025-05-27 13:24:30.352596+00	2025-05-27 13:24:30.352596+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:24:31.000Z", "contentLength": 0, "httpStatusCode": 200}	c0b6d1df-d409-4dc5-b7e6-4aa3588d4063	\N	{}
49b9c7be-f9bc-4db2-80e1-468f31db53df	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--888-1_1748340908523.webm	\N	2025-05-27 10:15:09.833929+00	2025-05-27 10:15:09.833929+00	2025-05-27 10:15:09.833929+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T10:15:10.000Z", "contentLength": 0, "httpStatusCode": 200}	b4523ef8-844e-45c2-93ee-dc6776f901bb	\N	{}
8e197d08-4ac4-4ebb-a0a9-33c5c24eb20e	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--888-1_1748340908515.webm	\N	2025-05-27 10:15:09.866349+00	2025-05-27 10:15:09.866349+00	2025-05-27 10:15:09.866349+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T10:15:10.000Z", "contentLength": 0, "httpStatusCode": 200}	ec46b858-fb61-4509-98eb-8070cab15a28	\N	{}
c8ab222f-aec7-406f-aff9-cb0d3b5bce5e	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-10_1748352271130.webm	\N	2025-05-27 13:24:31.39374+00	2025-05-27 13:24:31.39374+00	2025-05-27 13:24:31.39374+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:24:32.000Z", "contentLength": 0, "httpStatusCode": 200}	6240d345-50fc-46b3-a216-5bd74e3e1c90	\N	{}
55fd0daf-b310-4d6c-a19c-2f83ab3595d6	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-10_1748352271558.webm	\N	2025-05-27 13:24:31.855611+00	2025-05-27 13:24:31.855611+00	2025-05-27 13:24:31.855611+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:24:32.000Z", "contentLength": 0, "httpStatusCode": 200}	cedb8994-5809-423b-af70-128995e489b7	\N	{}
9e9f3450-e3f0-4ee4-93a8-3e99b19968e5	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--je--123-1_1748348226921.webm	\N	2025-05-27 12:17:08.323281+00	2025-05-27 12:17:08.323281+00	2025-05-27 12:17:08.323281+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T12:17:09.000Z", "contentLength": 0, "httpStatusCode": 200}	72592d30-931a-472e-88d2-abe0c38596d7	\N	{}
d7dca799-522e-49b1-86d2-3f2be6433170	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--je--123-1_1748348226904.webm	\N	2025-05-27 12:17:08.386009+00	2025-05-27 12:17:08.386009+00	2025-05-27 12:17:08.386009+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T12:17:09.000Z", "contentLength": 0, "httpStatusCode": 200}	d845b187-d22a-405d-a640-31c332709cb7	\N	{}
93ce4a63-755d-404e-8ced-95aa2072d4c4	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--je--123-1_1748348226898.webm	\N	2025-05-27 12:17:08.451914+00	2025-05-27 12:17:08.451914+00	2025-05-27 12:17:08.451914+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T12:17:09.000Z", "contentLength": 0, "httpStatusCode": 200}	ab162d6d-0dff-40c6-ab97-5e8ec948218b	\N	{}
9a3c7365-c4bb-47cc-9c80-afc1cc1529d0	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--je--123-1_1748348227059.webm	\N	2025-05-27 12:17:08.560742+00	2025-05-27 12:17:08.560742+00	2025-05-27 12:17:08.560742+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T12:17:09.000Z", "contentLength": 0, "httpStatusCode": 200}	2c24620c-bf3f-452d-b119-f209223237a8	\N	{}
afa43634-6ba6-47af-92d3-a12f94538db5	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--33-1_1748350319722.webm	\N	2025-05-27 12:52:00.012916+00	2025-05-27 12:52:00.012916+00	2025-05-27 12:52:00.012916+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T12:52:00.000Z", "contentLength": 0, "httpStatusCode": 200}	2e8535fd-b367-4b54-b89a-fd94f7d7d6cd	\N	{}
34d96cab-db98-4142-995c-f89f9cff46c1	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--33-1_1748350320425.webm	\N	2025-05-27 12:52:00.547365+00	2025-05-27 12:52:00.547365+00	2025-05-27 12:52:00.547365+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T12:52:01.000Z", "contentLength": 0, "httpStatusCode": 200}	79a5a4dd-25b5-41b0-bd7b-e84719faa006	\N	{}
e8a80adb-357c-4920-b7b1-b9fbf4353d1d	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--123-2_1748394023977.webm	\N	2025-05-28 01:00:24.018223+00	2025-05-28 01:00:24.018223+00	2025-05-28 01:00:24.018223+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T01:00:25.000Z", "contentLength": 0, "httpStatusCode": 200}	35f34644-816a-46b1-b156-6671fa3510ea	\N	{}
c65571b5-2a68-46d2-ab3b-03f6c85e60de	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-10_1748352272990.webm	\N	2025-05-27 13:24:33.246733+00	2025-05-27 13:24:33.246733+00	2025-05-27 13:24:33.246733+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:24:34.000Z", "contentLength": 0, "httpStatusCode": 200}	9c1283b6-e151-405b-8453-c0db0efa18eb	\N	{}
3fc4dc11-b923-4986-97c3-fa7b4126e0d6	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--33-2_1748350327852.webm	\N	2025-05-27 12:52:08.081466+00	2025-05-27 12:52:08.081466+00	2025-05-27 12:52:08.081466+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T12:52:09.000Z", "contentLength": 0, "httpStatusCode": 200}	9e4dffb5-62f0-4228-8796-335574674efd	\N	{}
ac6a37f1-6d77-4a10-9915-43d0b8dbbd21	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--33-2_1748350327959.webm	\N	2025-05-27 12:52:08.135621+00	2025-05-27 12:52:08.135621+00	2025-05-27 12:52:08.135621+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T12:52:09.000Z", "contentLength": 0, "httpStatusCode": 200}	3cadf17a-148d-4608-9cfc-37f7e1ff8686	\N	{}
1e43a042-09d7-46ab-a681-95a02ecee5ea	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--45-1_1748350679407.webm	\N	2025-05-27 12:57:59.656497+00	2025-05-27 12:57:59.656497+00	2025-05-27 12:57:59.656497+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T12:58:00.000Z", "contentLength": 0, "httpStatusCode": 200}	54cd97fd-3d37-497c-ad07-d2b9a7e367f1	\N	{}
38dc25d2-ed4a-4758-bcbc-b4ae60cdb446	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-10_1748352274367.webm	\N	2025-05-27 13:24:34.654999+00	2025-05-27 13:24:34.654999+00	2025-05-27 13:24:34.654999+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:24:35.000Z", "contentLength": 0, "httpStatusCode": 200}	6188b927-618c-4987-833d-710dfe0fd262	\N	{}
f931e897-99d5-41d9-9921-8cf6286ce6ec	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--45-1_1748350682823.webm	\N	2025-05-27 12:58:02.938153+00	2025-05-27 12:58:02.938153+00	2025-05-27 12:58:02.938153+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T12:58:03.000Z", "contentLength": 0, "httpStatusCode": 200}	9aee1e40-9193-43de-afd3-75fdc2314ff3	\N	{}
049738d9-cec9-408f-9698-3c2c17a29628	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--123-2_1748394027470.webm	\N	2025-05-28 01:00:27.455752+00	2025-05-28 01:00:27.455752+00	2025-05-28 01:00:27.455752+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T01:00:28.000Z", "contentLength": 0, "httpStatusCode": 200}	ee631013-ce26-417a-9d86-58a70d5cc792	\N	{}
13e4e41e-4243-45db-bd6a-c2cad4e6865a	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--45-1_1748350683228.webm	\N	2025-05-27 12:58:03.349271+00	2025-05-27 12:58:03.349271+00	2025-05-27 12:58:03.349271+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T12:58:04.000Z", "contentLength": 0, "httpStatusCode": 200}	d589b223-9509-43ef-897e-453e4f30ba74	\N	{}
5a6ecda6-f3e1-4404-9b3b-3e063a3f1cbd	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-11_1748352302125.webm	\N	2025-05-27 13:25:02.643213+00	2025-05-27 13:25:02.643213+00	2025-05-27 13:25:02.643213+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:25:03.000Z", "contentLength": 0, "httpStatusCode": 200}	9537fcf1-5d41-4010-bc7f-e40a52199092	\N	{}
abddb2c9-b25f-4e6e-a002-a978d4af6044	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--888-1_1748350870446.webm	\N	2025-05-27 13:01:10.637819+00	2025-05-27 13:01:10.637819+00	2025-05-27 13:01:10.637819+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:01:11.000Z", "contentLength": 0, "httpStatusCode": 200}	26c18e19-a399-45c8-9ad4-c6b094c20e0f	\N	{}
837e36ad-2e75-4a2b-b5ef-61d37772d025	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--888-1_1748350909471.webm	\N	2025-05-27 13:01:49.69936+00	2025-05-27 13:01:49.69936+00	2025-05-27 13:01:49.69936+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:01:50.000Z", "contentLength": 0, "httpStatusCode": 200}	691abcf6-3126-455d-9660-eb0eb09b4e95	\N	{}
9ddd8855-e80a-4390-ac6e-74da0a78195b	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--888-1_1748350909488.webm	\N	2025-05-27 13:01:49.705209+00	2025-05-27 13:01:49.705209+00	2025-05-27 13:01:49.705209+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:01:50.000Z", "contentLength": 0, "httpStatusCode": 200}	9466b5bc-13d9-4ec6-85d4-be88cd1017a9	\N	{}
efb5b604-f770-4296-a903-22d07ae00911	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--888-2_1748350912165.webm	\N	2025-05-27 13:01:52.284159+00	2025-05-27 13:01:52.284159+00	2025-05-27 13:01:52.284159+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:01:53.000Z", "contentLength": 0, "httpStatusCode": 200}	76cb165e-f74a-4981-9368-b80b7259cead	\N	{}
f0321c88-8d5c-467c-ac39-5ae54827cbe7	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--888-3_1748351063807.webm	\N	2025-05-27 13:04:23.962758+00	2025-05-27 13:04:23.962758+00	2025-05-27 13:04:23.962758+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:04:24.000Z", "contentLength": 0, "httpStatusCode": 200}	4d4a209e-d33d-4a62-8794-e613d6b40b05	\N	{}
d8c39315-f738-49a1-bdef-605fc5532a77	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-3_1748769107207.webm	\N	2025-06-01 09:11:47.667014+00	2025-06-01 09:11:47.667014+00	2025-06-01 09:11:47.667014+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-06-01T09:11:48.000Z", "contentLength": 0, "httpStatusCode": 200}	0ec93d2a-55e0-40dd-9b63-891447f814ac	\N	{}
a3857f21-fb8b-4dbc-b6c3-e23a7ba14347	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-10_1748352274370.webm	\N	2025-05-27 13:24:34.650758+00	2025-05-27 13:24:34.650758+00	2025-05-27 13:24:34.650758+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:24:35.000Z", "contentLength": 0, "httpStatusCode": 200}	844ec713-50da-45e2-ab03-6742b62e76e5	\N	{}
20200f11-ca74-4754-b2b1-61ce733bac77	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--123-1_1748351316500.webm	\N	2025-05-27 13:08:36.704563+00	2025-05-27 13:08:36.704563+00	2025-05-27 13:08:36.704563+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:08:37.000Z", "contentLength": 0, "httpStatusCode": 200}	848fd961-115d-43ad-863a-fa2b177fbf24	\N	{}
ba7067f3-bac9-43dc-85e6-3544bde0db54	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--je--1-2_1748352574318.webm	\N	2025-05-27 13:29:34.580659+00	2025-05-27 13:29:34.580659+00	2025-05-27 13:29:34.580659+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:29:35.000Z", "contentLength": 0, "httpStatusCode": 200}	9e17849b-d1fa-409f-9293-e4f3bec33407	\N	{}
268d92a4-4268-41c2-93d6-17d8cefb4a85	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--123-1_1748351319697.webm	\N	2025-05-27 13:08:39.794088+00	2025-05-27 13:08:39.794088+00	2025-05-27 13:08:39.794088+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:08:40.000Z", "contentLength": 0, "httpStatusCode": 200}	0b6312b9-867b-4c32-bdc0-7b2c120f4fb3	\N	{}
ed3119ad-ce9b-4c26-8db0-c54c089f1e1f	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--123-1_1748351320007.webm	\N	2025-05-27 13:08:40.102995+00	2025-05-27 13:08:40.102995+00	2025-05-27 13:08:40.102995+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:08:41.000Z", "contentLength": 0, "httpStatusCode": 200}	2b349dcd-b0e5-4b65-9fc9-c31b09bdf16e	\N	{}
8a9b2697-3e12-433b-b8bd-25b4d852404e	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--je--1-2_1748352574460.webm	\N	2025-05-27 13:29:34.695897+00	2025-05-27 13:29:34.695897+00	2025-05-27 13:29:34.695897+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:29:35.000Z", "contentLength": 0, "httpStatusCode": 200}	eaf9281e-14bb-44cf-83b7-bd27562a1fa3	\N	{}
075b20f9-7303-476d-8190-90e346e38444	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--123-2_1748351366237.webm	\N	2025-05-27 13:09:26.438639+00	2025-05-27 13:09:26.438639+00	2025-05-27 13:09:26.438639+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:09:27.000Z", "contentLength": 0, "httpStatusCode": 200}	f27119ae-1380-4e5e-a894-51229596564c	\N	{}
1a1f7a2f-0b7d-4e12-b7d2-2e08cc0197e2	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--123-3_1748351464517.webm	\N	2025-05-27 13:11:04.737001+00	2025-05-27 13:11:04.737001+00	2025-05-27 13:11:04.737001+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:11:05.000Z", "contentLength": 0, "httpStatusCode": 200}	5e94496c-a8fd-4e75-ac26-e45af277ae67	\N	{}
45acac58-1046-4b0a-afb3-8a272642d605	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-13_1748352618042.webm	\N	2025-05-27 13:30:18.391649+00	2025-05-27 13:30:18.391649+00	2025-05-27 13:30:18.391649+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:30:19.000Z", "contentLength": 0, "httpStatusCode": 200}	2fe77c48-8448-4f25-991d-0ca68923e071	\N	{}
07b272a3-d501-4d44-a7b0-86d79918c005	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--123-3_1748351466599.webm	\N	2025-05-27 13:11:06.697718+00	2025-05-27 13:11:06.697718+00	2025-05-27 13:11:06.697718+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:11:07.000Z", "contentLength": 0, "httpStatusCode": 200}	ff8bc419-b106-446d-889d-1e2adabd9b24	\N	{}
1a8584a6-8cc0-40ee-983a-e75b14045ee8	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--123-4_1748351491287.webm	\N	2025-05-27 13:11:31.490587+00	2025-05-27 13:11:31.490587+00	2025-05-27 13:11:31.490587+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:11:32.000Z", "contentLength": 0, "httpStatusCode": 200}	861b9a11-20e3-43aa-bbec-c255e7a2adc3	\N	{}
9458c8c7-c628-4680-8440-68f6cd3cb758	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--123-4_1748351498313.webm	\N	2025-05-27 13:11:38.460551+00	2025-05-27 13:11:38.460551+00	2025-05-27 13:11:38.460551+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:11:39.000Z", "contentLength": 0, "httpStatusCode": 200}	2d8c539e-7571-4022-9ca1-e289ad22844c	\N	{}
a26ac107-5c25-4588-9491-1c7013d5c330	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--123-4_1748351498782.webm	\N	2025-05-27 13:11:38.873269+00	2025-05-27 13:11:38.873269+00	2025-05-27 13:11:38.873269+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:11:39.000Z", "contentLength": 0, "httpStatusCode": 200}	dcd1c942-e726-438b-bb04-0fb025f8077a	\N	{}
4f8e290b-a0d3-40df-971d-507a4d6e11ee	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-11_1748352303410.webm	\N	2025-05-27 13:25:03.667612+00	2025-05-27 13:25:03.667612+00	2025-05-27 13:25:03.667612+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:25:04.000Z", "contentLength": 0, "httpStatusCode": 200}	015c63a0-e624-4589-82c6-e4d597503596	\N	{}
6ce8094e-5c4a-42ad-8c5b-6b9cd069e522	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--123-4_1748351503448.webm	\N	2025-05-27 13:11:43.528647+00	2025-05-27 13:11:43.528647+00	2025-05-27 13:11:43.528647+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:11:44.000Z", "contentLength": 0, "httpStatusCode": 200}	62a4fa24-e455-4097-a6a0-6eca9cfc33ca	\N	{}
7dedf420-312e-40a2-bcfc-449ee0039795	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-3_1748769108523.webm	\N	2025-06-01 09:11:48.767974+00	2025-06-01 09:11:48.767974+00	2025-06-01 09:11:48.767974+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-06-01T09:11:49.000Z", "contentLength": 0, "httpStatusCode": 200}	84403c7c-879c-4b6e-98a7-e4d512a9b338	\N	{}
a54fc9c4-9810-4b73-a9e2-f678f681d9a5	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--123-5_1748351525295.webm	\N	2025-05-27 13:12:05.457062+00	2025-05-27 13:12:05.457062+00	2025-05-27 13:12:05.457062+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:12:06.000Z", "contentLength": 0, "httpStatusCode": 200}	3ced83b2-84a9-4bb3-b842-9b77ef24611d	\N	{}
9d0580c8-d131-4d92-92ba-b3185773983e	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-11_1748352304612.webm	\N	2025-05-27 13:25:04.886297+00	2025-05-27 13:25:04.886297+00	2025-05-27 13:25:04.886297+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:25:05.000Z", "contentLength": 0, "httpStatusCode": 200}	cdc7f309-dcbf-4030-bd8f-933a7604a9a9	\N	{}
de30fe84-fb41-429f-b13b-b9c4120124bb	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--123-5_1748351570501.webm	\N	2025-05-27 13:12:50.723108+00	2025-05-27 13:12:50.723108+00	2025-05-27 13:12:50.723108+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:12:51.000Z", "contentLength": 0, "httpStatusCode": 200}	ca81c68d-bfa1-40df-8c58-fb3e04bcecbf	\N	{}
5de7766c-3efc-44c5-8cc4-2ed12fbd4c19	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--123-3_1748394957998.webm	\N	2025-05-28 01:15:58.064468+00	2025-05-28 01:15:58.064468+00	2025-05-28 01:15:58.064468+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T01:15:59.000Z", "contentLength": 0, "httpStatusCode": 200}	dd6c1828-52ef-4198-8a71-1c25d95b9b6c	\N	{}
c0e0da0d-d498-4974-8cd7-240d15f81d82	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--123-5_1748351570998.webm	\N	2025-05-27 13:12:51.159144+00	2025-05-27 13:12:51.159144+00	2025-05-27 13:12:51.159144+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:12:52.000Z", "contentLength": 0, "httpStatusCode": 200}	633cc02d-563e-46e0-aa09-7fa0201eeb74	\N	{}
23fc7bd4-9c8a-407e-bfc9-a6fbca966f37	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--123-5_1748351572691.webm	\N	2025-05-27 13:12:52.82483+00	2025-05-27 13:12:52.82483+00	2025-05-27 13:12:52.82483+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:12:53.000Z", "contentLength": 0, "httpStatusCode": 200}	70a8693f-827e-49ab-806b-432c423f7935	\N	{}
e39c5f3e-9c54-4b77-b5e4-95ef0f6898a3	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--123-5_1748351572769.webm	\N	2025-05-27 13:12:52.882541+00	2025-05-27 13:12:52.882541+00	2025-05-27 13:12:52.882541+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:12:53.000Z", "contentLength": 0, "httpStatusCode": 200}	3bd4adc8-75a4-45f3-867d-b84bd65375de	\N	{}
ab036ae0-b1a3-4410-afc0-4683e9a5d32c	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--je--1-1_1748352432130.webm	\N	2025-05-27 13:27:12.433321+00	2025-05-27 13:27:12.433321+00	2025-05-27 13:27:12.433321+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:27:13.000Z", "contentLength": 0, "httpStatusCode": 200}	4b00bed8-a7b9-4eb3-8c3a-5fa7b897442b	\N	{}
11617d17-b992-42fd-ac74-ef6aeb5e8fd2	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--123-6_1748351663608.webm	\N	2025-05-27 13:14:23.838626+00	2025-05-27 13:14:23.838626+00	2025-05-27 13:14:23.838626+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:14:24.000Z", "contentLength": 0, "httpStatusCode": 200}	606dd8aa-4dff-465e-9eb4-8cf6a00e1186	\N	{}
6e09d235-6d54-4c16-a9fc-32eafbed4876	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--123-6_1748351673720.webm	\N	2025-05-27 13:14:33.977467+00	2025-05-27 13:14:33.977467+00	2025-05-27 13:14:33.977467+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:14:34.000Z", "contentLength": 0, "httpStatusCode": 200}	3fa29c8e-8652-464a-8f5a-3ba3c89b9078	\N	{}
1f86277d-480b-42e6-92af-80ce055551d3	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--123-6_1748351674190.webm	\N	2025-05-27 13:14:34.345963+00	2025-05-27 13:14:34.345963+00	2025-05-27 13:14:34.345963+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:14:35.000Z", "contentLength": 0, "httpStatusCode": 200}	2ef45f6b-0edf-4582-832c-01298ffa9ae4	\N	{}
616919b8-443b-4d7e-99f6-0129a20296e0	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--je--1-1_1748352432145.webm	\N	2025-05-27 13:27:12.642161+00	2025-05-27 13:27:12.642161+00	2025-05-27 13:27:12.642161+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:27:13.000Z", "contentLength": 0, "httpStatusCode": 200}	ef510b30-1ead-4356-bc18-d1425880aad8	\N	{}
dba47f98-aa55-435f-8213-5b5cac922086	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--123-6_1748351674642.webm	\N	2025-05-27 13:14:34.804248+00	2025-05-27 13:14:34.804248+00	2025-05-27 13:14:34.804248+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:14:35.000Z", "contentLength": 0, "httpStatusCode": 200}	0a0d8c7f-0ab7-4c1d-9066-dbf8aa8de1c2	\N	{}
351e4bfa-4dac-4c49-8f82-3ee9940b808d	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--123-3_1748394963443.webm	\N	2025-05-28 01:16:03.581082+00	2025-05-28 01:16:03.581082+00	2025-05-28 01:16:03.581082+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T01:16:04.000Z", "contentLength": 0, "httpStatusCode": 200}	08b174d7-7461-4cf3-9a96-f503995c4e52	\N	{}
1e663d34-ddf1-421f-bfef-2dc019548101	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--123-6_1748351677186.webm	\N	2025-05-27 13:14:37.330679+00	2025-05-27 13:14:37.330679+00	2025-05-27 13:14:37.330679+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:14:38.000Z", "contentLength": 0, "httpStatusCode": 200}	96a36804-0e59-4a25-ab46-6c6ee6272e00	\N	{}
443dbbc1-0300-4c49-8456-bea718fc7126	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--je--1-1_1748352432832.webm	\N	2025-05-27 13:27:13.060435+00	2025-05-27 13:27:13.060435+00	2025-05-27 13:27:13.060435+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:27:14.000Z", "contentLength": 0, "httpStatusCode": 200}	7bdc8ccf-e8c9-4ce1-97b7-94f0e32c3833	\N	{}
719bf44b-b7cb-416a-a490-66d8209131af	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-3_1748769108642.webm	\N	2025-06-01 09:11:48.938909+00	2025-06-01 09:11:48.938909+00	2025-06-01 09:11:48.938909+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-06-01T09:11:49.000Z", "contentLength": 0, "httpStatusCode": 200}	07aa9f1d-c688-4a88-a3eb-4ed12f3b4da5	\N	{}
486fe88d-863d-4b50-aa94-c53d86a8cf7c	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--je--1-2_1748352490978.webm	\N	2025-05-27 13:28:11.254502+00	2025-05-27 13:28:11.254502+00	2025-05-27 13:28:11.254502+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:28:12.000Z", "contentLength": 0, "httpStatusCode": 200}	50180281-48b1-4eb3-bdbd-a1833f2ef272	\N	{}
a6a81fbe-652a-44d0-b81f-ee7506ca4bd8	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-12_1748352493447.webm	\N	2025-05-27 13:28:13.814588+00	2025-05-27 13:28:13.814588+00	2025-05-27 13:28:13.814588+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:28:14.000Z", "contentLength": 0, "httpStatusCode": 200}	0c1b93cf-6c00-46b8-993a-af2da05afdf2	\N	{}
89dcc7f8-d1cf-4cc0-b53e-88183edd8185	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--123-3_1748394963582.webm	\N	2025-05-28 01:16:03.788918+00	2025-05-28 01:16:03.788918+00	2025-05-28 01:16:03.788918+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T01:16:04.000Z", "contentLength": 0, "httpStatusCode": 200}	68e4e88b-2496-41af-bfe1-a72fe2e3637e	\N	{}
979ec51f-52b4-44e9-bb9e-9546f090ab8b	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-12_1748352494022.webm	\N	2025-05-27 13:28:14.291163+00	2025-05-27 13:28:14.291163+00	2025-05-27 13:28:14.291163+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:28:15.000Z", "contentLength": 0, "httpStatusCode": 200}	34da63a2-58d8-4f1c-ab06-e153cdc2fa4e	\N	{}
b6dae1b3-9b7f-4541-8a45-fb8fdcba0951	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--je--1-2_1748352572388.webm	\N	2025-05-27 13:29:32.690531+00	2025-05-27 13:29:32.690531+00	2025-05-27 13:29:32.690531+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:29:33.000Z", "contentLength": 0, "httpStatusCode": 200}	4a79a58f-41fc-4b15-8411-d04f77e3629b	\N	{}
8473e314-a670-443e-b915-150194246fec	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--je--1-2_1748352573402.webm	\N	2025-05-27 13:29:33.622754+00	2025-05-27 13:29:33.622754+00	2025-05-27 13:29:33.622754+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:29:34.000Z", "contentLength": 0, "httpStatusCode": 200}	e6dc574c-f7fd-4dd9-9fd2-5b3f5b1d983b	\N	{}
e71c2ed3-a8f0-4f56-a080-595ad96ba0a4	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--je--1-2_1748352573888.webm	\N	2025-05-27 13:29:34.107407+00	2025-05-27 13:29:34.107407+00	2025-05-27 13:29:34.107407+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:29:35.000Z", "contentLength": 0, "httpStatusCode": 200}	919dac04-4bb5-4a89-a4f8-9c0f399c89c1	\N	{}
8e8237f7-0b87-47b8-9699-90cda3cb6482	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-13_1748352618634.webm	\N	2025-05-27 13:30:18.91799+00	2025-05-27 13:30:18.91799+00	2025-05-27 13:30:18.91799+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:30:19.000Z", "contentLength": 0, "httpStatusCode": 200}	caa8d99e-cc18-428b-8e94-aa37356bb965	\N	{}
8504de1c-97d3-4f8a-a1a9-4f49248cf720	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--123-3_1748394963752.webm	\N	2025-05-28 01:16:03.80119+00	2025-05-28 01:16:03.80119+00	2025-05-28 01:16:03.80119+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T01:16:04.000Z", "contentLength": 0, "httpStatusCode": 200}	3f3fba74-9178-4fbd-95ae-f88135b6476c	\N	{}
c8e579a2-ca70-40e7-b2d6-37c2cf0bcff3	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-14_1748352627512.webm	\N	2025-05-27 13:30:27.948091+00	2025-05-27 13:30:27.948091+00	2025-05-27 13:30:27.948091+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:30:28.000Z", "contentLength": 0, "httpStatusCode": 200}	1fa0282e-1f17-4a50-ac58-7487de076b21	\N	{}
ddc9a011-4fe0-4d63-a636-ab6c580465e4	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-15_1748352647602.webm	\N	2025-05-27 13:30:47.974458+00	2025-05-27 13:30:47.974458+00	2025-05-27 13:30:47.974458+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:30:48.000Z", "contentLength": 0, "httpStatusCode": 200}	a25dc381-2c96-4577-8146-e10d8caf4c12	\N	{}
92bfd1bd-5e25-42d4-b992-af46d5e187d6	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--123-4_1748395095514.webm	\N	2025-05-28 01:18:15.667182+00	2025-05-28 01:18:15.667182+00	2025-05-28 01:18:15.667182+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T01:18:16.000Z", "contentLength": 0, "httpStatusCode": 200}	14da9d8a-7d6a-4eb7-ae95-e2e2694ff5e2	\N	{}
2a6c14bb-054c-4693-af4d-7515b3ea10f7	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-15_1748352648184.webm	\N	2025-05-27 13:30:48.45038+00	2025-05-27 13:30:48.45038+00	2025-05-27 13:30:48.45038+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:30:49.000Z", "contentLength": 0, "httpStatusCode": 200}	5dfda294-256f-4c39-b896-ae66f684fadc	\N	{}
e6469a15-4005-4041-a035-5a18e417be46	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--123-4_1748395095527.webm	\N	2025-05-28 01:18:15.704064+00	2025-05-28 01:18:15.704064+00	2025-05-28 01:18:15.704064+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T01:18:16.000Z", "contentLength": 0, "httpStatusCode": 200}	00bb8136-d7e8-421a-a3d6-99c0a79ac388	\N	{}
a80b1b8f-5dc3-4a8d-8234-243c4f9ee0a1	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-16_1748352654740.webm	\N	2025-05-27 13:30:55.10943+00	2025-05-27 13:30:55.10943+00	2025-05-27 13:30:55.10943+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:30:56.000Z", "contentLength": 0, "httpStatusCode": 200}	c4d6b78d-d941-4dc5-9827-70260c0f602a	\N	{}
491d7012-04aa-4638-92ca-d05526cf348c	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-16_1748352654741.webm	\N	2025-05-27 13:30:55.12654+00	2025-05-27 13:30:55.12654+00	2025-05-27 13:30:55.12654+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:30:56.000Z", "contentLength": 0, "httpStatusCode": 200}	8d7a9548-c622-4adc-9d97-4ac11c3db0f5	\N	{}
36c9e22e-9642-476f-ae5b-593ceeb0661c	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-19_1748352706567.webm	\N	2025-05-27 13:31:46.849056+00	2025-05-27 13:31:46.849056+00	2025-05-27 13:31:46.849056+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:31:47.000Z", "contentLength": 0, "httpStatusCode": 200}	03c64bd2-0492-4b4f-b91a-2c117a6fcc93	\N	{}
c6d57c01-85a5-4022-82e9-929f018ebbf6	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--123-4_1748395095932.webm	\N	2025-05-28 01:18:16.034183+00	2025-05-28 01:18:16.034183+00	2025-05-28 01:18:16.034183+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T01:18:17.000Z", "contentLength": 0, "httpStatusCode": 200}	7d681c34-f467-46aa-ba0d-326a8f31c86d	\N	{}
5a509b9b-6392-42f7-ad4e-5816ce817045	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--123-4_1748395097187.webm	\N	2025-05-28 01:18:17.268411+00	2025-05-28 01:18:17.268411+00	2025-05-28 01:18:17.268411+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T01:18:18.000Z", "contentLength": 0, "httpStatusCode": 200}	7f826971-f0cc-4045-8624-05b79c80bac1	\N	{}
8eac7b9a-81bc-4a64-968d-9ffdfdaead90	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-18_1748352694980.webm	\N	2025-05-27 13:31:35.438326+00	2025-05-27 13:31:35.438326+00	2025-05-27 13:31:35.438326+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:31:36.000Z", "contentLength": 0, "httpStatusCode": 200}	b29a0f91-e216-4fd1-affd-ab82a36b9e5c	\N	{}
fd4188d9-7786-4f8b-8d87-a5e002898651	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--123-5_1748395683909.webm	\N	2025-05-28 01:28:04.103288+00	2025-05-28 01:28:04.103288+00	2025-05-28 01:28:04.103288+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T01:28:05.000Z", "contentLength": 0, "httpStatusCode": 200}	1c26ef78-c2f6-42f0-b664-f6eba2a8417f	\N	{}
d600eead-aaea-4ad2-b323-06e07c68a148	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-18_1748352695667.webm	\N	2025-05-27 13:31:35.947917+00	2025-05-27 13:31:35.947917+00	2025-05-27 13:31:35.947917+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:31:36.000Z", "contentLength": 0, "httpStatusCode": 200}	da7e4fd9-5144-45b5-93af-56fa43399775	\N	{}
22ed4ad6-95db-43c4-8a2f-39957cd26fb2	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-19_1748352706277.webm	\N	2025-05-27 13:31:46.638497+00	2025-05-27 13:31:46.638497+00	2025-05-27 13:31:46.638497+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:31:47.000Z", "contentLength": 0, "httpStatusCode": 200}	5f4c2682-6139-4041-a9d5-87774c767bc2	\N	{}
3ed73481-79c4-4240-a13d-64cf5c4854c0	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--123-5_1748395687892.webm	\N	2025-05-28 01:28:08.079529+00	2025-05-28 01:28:08.079529+00	2025-05-28 01:28:08.079529+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T01:28:08.000Z", "contentLength": 0, "httpStatusCode": 200}	19d436cc-0769-4bc8-9091-eab538666bbb	\N	{}
5d7648c6-183f-49d4-ad69-f1b71fdab2bf	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-19_1748352706910.webm	\N	2025-05-27 13:31:47.169625+00	2025-05-27 13:31:47.169625+00	2025-05-27 13:31:47.169625+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:31:48.000Z", "contentLength": 0, "httpStatusCode": 200}	11e47ec7-d7d7-4248-97ee-626f680b8a78	\N	{}
72fe2824-f9f9-4950-aae6-627c9cf34dcb	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--123-5_1748395687955.webm	\N	2025-05-28 01:28:08.124633+00	2025-05-28 01:28:08.124633+00	2025-05-28 01:28:08.124633+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T01:28:09.000Z", "contentLength": 0, "httpStatusCode": 200}	f242278e-909c-4659-a91e-aeb366f46e0a	\N	{}
a7512304-10d7-42d4-a328-ba514a4c5e3d	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-20_1748352719877.webm	\N	2025-05-27 13:32:00.273445+00	2025-05-27 13:32:00.273445+00	2025-05-27 13:32:00.273445+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:32:01.000Z", "contentLength": 0, "httpStatusCode": 200}	90e1a456-3c4f-4c8f-91b3-974217f88a45	\N	{}
5a9597c2-9aa2-4d0e-a5ff-ad0341581239	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-20_1748352720441.webm	\N	2025-05-27 13:32:00.721713+00	2025-05-27 13:32:00.721713+00	2025-05-27 13:32:00.721713+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:32:01.000Z", "contentLength": 0, "httpStatusCode": 200}	d37829e7-eb90-446b-86a0-ab2d6e307a08	\N	{}
7e4e1fcd-8daa-401d-8205-c83824539e4e	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-20_1748352721064.webm	\N	2025-05-27 13:32:01.429908+00	2025-05-27 13:32:01.429908+00	2025-05-27 13:32:01.429908+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:32:02.000Z", "contentLength": 0, "httpStatusCode": 200}	79807fbf-53ee-4e01-babb-5dbd2048bc1b	\N	{}
51cb4338-3a1a-457f-958d-dd3e35197f45	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-20_1748352721286.webm	\N	2025-05-27 13:32:01.648758+00	2025-05-27 13:32:01.648758+00	2025-05-27 13:32:01.648758+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:32:02.000Z", "contentLength": 0, "httpStatusCode": 200}	59a4dd56-3ed5-4ba2-a009-b9b2f2bb87b4	\N	{}
bc025f33-d3ac-4cc6-af55-b6900dfd33cc	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-21_1748352730470.webm	\N	2025-05-27 13:32:10.809092+00	2025-05-27 13:32:10.809092+00	2025-05-27 13:32:10.809092+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:32:11.000Z", "contentLength": 0, "httpStatusCode": 200}	0fdf01e6-60fb-4f9f-85fc-ae2c6bb599d3	\N	{}
fd4d38a0-9b26-44b5-8139-0905311c126a	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-21_1748352731404.webm	\N	2025-05-27 13:32:11.683668+00	2025-05-27 13:32:11.683668+00	2025-05-27 13:32:11.683668+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:32:12.000Z", "contentLength": 0, "httpStatusCode": 200}	06a05b71-0686-42ef-ac81-a081ecc340c7	\N	{}
b2866330-a00e-459d-a025-489cac070114	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-21_1748352731659.webm	\N	2025-05-27 13:32:11.93883+00	2025-05-27 13:32:11.93883+00	2025-05-27 13:32:11.93883+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:32:12.000Z", "contentLength": 0, "httpStatusCode": 200}	c5f9a6a1-edc9-4731-89ba-750d7850eda5	\N	{}
2e31a885-2b53-4369-a0a2-0f0ba8c6bcd6	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--123-6_1748395718469.webm	\N	2025-05-28 01:28:38.681269+00	2025-05-28 01:28:38.681269+00	2025-05-28 01:28:38.681269+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T01:28:39.000Z", "contentLength": 0, "httpStatusCode": 200}	75813363-543b-4df3-9a13-0a06966e4d71	\N	{}
418c6357-49eb-464b-a23e-2155f265ada5	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--123-6_1748395718785.webm	\N	2025-05-28 01:28:38.897339+00	2025-05-28 01:28:38.897339+00	2025-05-28 01:28:38.897339+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T01:28:39.000Z", "contentLength": 0, "httpStatusCode": 200}	ff22fb4f-6ea2-4943-904f-04d678668ee8	\N	{}
d78d4869-ea99-4771-8b25-886f94f88912	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--123-6_1748395718821.webm	\N	2025-05-28 01:28:38.92964+00	2025-05-28 01:28:38.92964+00	2025-05-28 01:28:38.92964+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T01:28:39.000Z", "contentLength": 0, "httpStatusCode": 200}	c3b48be2-792c-412e-a70d-0d52de875022	\N	{}
2c64a4fd-583d-47c0-ba3c-555b36e06108	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-3_1748401906358.webm	\N	2025-05-28 03:11:46.524158+00	2025-05-28 03:11:46.524158+00	2025-05-28 03:11:46.524158+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T03:11:47.000Z", "contentLength": 0, "httpStatusCode": 200}	0f848800-bb76-47a6-9be8-bd74fd5ff169	\N	{}
33f89f73-1322-4b71-95dc-5efe8c1c956e	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-3_1748401906370.webm	\N	2025-05-28 03:11:46.571168+00	2025-05-28 03:11:46.571168+00	2025-05-28 03:11:46.571168+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T03:11:47.000Z", "contentLength": 0, "httpStatusCode": 200}	cd54b6e2-fc60-4702-bac2-40ffe5f2888a	\N	{}
583c1e91-a28f-45e0-9179-82167e096e0a	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-5_1748402952309.webm	\N	2025-05-28 03:29:13.795985+00	2025-05-28 03:29:13.795985+00	2025-05-28 03:29:13.795985+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T03:29:14.000Z", "contentLength": 0, "httpStatusCode": 200}	942c3c03-ea3c-44ee-bc1e-c0774872b8c0	\N	{}
90402fad-6a85-44a9-92aa-9945e2910544	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-7_1748403570985.webm	\N	2025-05-28 03:39:31.159436+00	2025-05-28 03:39:31.159436+00	2025-05-28 03:39:31.159436+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T03:39:32.000Z", "contentLength": 0, "httpStatusCode": 200}	05275f10-f39d-4889-962a-217f01cab720	\N	{}
00c6ac86-b7ed-4f0e-b490-29ffa6f195ce	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-8_1748403619687.webm	\N	2025-05-28 03:40:19.891157+00	2025-05-28 03:40:19.891157+00	2025-05-28 03:40:19.891157+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T03:40:20.000Z", "contentLength": 0, "httpStatusCode": 200}	70d3eec3-029e-4950-b5d2-a4ac94ac060c	\N	{}
a10c8a7f-9060-4902-b712-72a5fdc1b949	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-8_1748403622369.webm	\N	2025-05-28 03:40:22.495436+00	2025-05-28 03:40:22.495436+00	2025-05-28 03:40:22.495436+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T03:40:23.000Z", "contentLength": 0, "httpStatusCode": 200}	622a1f87-aa2c-42f3-9e85-2ea6247ed5e4	\N	{}
8114e178-1df6-4ae6-b99a-12b16ece3619	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-22_1748352765032.webm	\N	2025-05-27 13:32:45.403833+00	2025-05-27 13:32:45.403833+00	2025-05-27 13:32:45.403833+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:32:46.000Z", "contentLength": 0, "httpStatusCode": 200}	e144a254-ff81-4a31-9950-5ae8088d6c0a	\N	{}
4aef2534-5896-4389-b6dc-17ba3e5bd0de	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-22_1748352765484.webm	\N	2025-05-27 13:32:45.76024+00	2025-05-27 13:32:45.76024+00	2025-05-27 13:32:45.76024+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:32:46.000Z", "contentLength": 0, "httpStatusCode": 200}	6da3279c-38ae-471a-9326-6b4e25d1b332	\N	{}
e6d4caf1-80d8-4455-84d1-f2ee5b29a311	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-1_1748401241266.webm	\N	2025-05-28 03:00:41.503586+00	2025-05-28 03:00:41.503586+00	2025-05-28 03:00:41.503586+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T03:00:42.000Z", "contentLength": 0, "httpStatusCode": 200}	f7cbc50f-19e5-42fb-9d49-f89e9e8ca2b1	\N	{}
284702a9-b643-4ded-bf53-10489b87dea1	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-23_1748352771646.webm	\N	2025-05-27 13:32:51.995233+00	2025-05-27 13:32:51.995233+00	2025-05-27 13:32:51.995233+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:32:52.000Z", "contentLength": 0, "httpStatusCode": 200}	46916fba-fce9-45d2-8371-53c174cbe72d	\N	{}
418e7378-7b35-484b-9c48-1cf7ccac36ca	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-23_1748352773392.webm	\N	2025-05-27 13:32:53.676453+00	2025-05-27 13:32:53.676453+00	2025-05-27 13:32:53.676453+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:32:54.000Z", "contentLength": 0, "httpStatusCode": 200}	7d5dcaa2-a83a-456c-8e06-f7b1f44d4c17	\N	{}
6530a2b6-2c30-4d5e-941b-9b48c0ef6bac	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-1_1748401241458.webm	\N	2025-05-28 03:00:41.615617+00	2025-05-28 03:00:41.615617+00	2025-05-28 03:00:41.615617+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T03:00:42.000Z", "contentLength": 0, "httpStatusCode": 200}	aa33c211-270d-4a8e-929f-b41bda5d4453	\N	{}
4f1373db-a04d-413a-970c-d64b1741af10	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-23_1748352775547.webm	\N	2025-05-27 13:32:55.832351+00	2025-05-27 13:32:55.832351+00	2025-05-27 13:32:55.832351+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:32:56.000Z", "contentLength": 0, "httpStatusCode": 200}	1df21be6-c757-4456-927d-cb6c59165ebd	\N	{}
bfe4b932-b234-4528-b8fe-3fc273d99a39	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-23_1748352775678.webm	\N	2025-05-27 13:32:55.950234+00	2025-05-27 13:32:55.950234+00	2025-05-27 13:32:55.950234+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:32:56.000Z", "contentLength": 0, "httpStatusCode": 200}	d68afff8-34f9-42c2-846b-7be645eefd59	\N	{}
b0fbe875-aa89-44ab-a7a5-1119b1ad5c6a	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-1_1748401241661.webm	\N	2025-05-28 03:00:41.826837+00	2025-05-28 03:00:41.826837+00	2025-05-28 03:00:41.826837+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T03:00:42.000Z", "contentLength": 0, "httpStatusCode": 200}	932393f0-bde2-4b26-a26c-88b0bdca2c56	\N	{}
e7922f59-ff80-4916-ab38-b3a5d55a9d7f	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--je--1-3_1748352874249.webm	\N	2025-05-27 13:34:34.633028+00	2025-05-27 13:34:34.633028+00	2025-05-27 13:34:34.633028+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:34:35.000Z", "contentLength": 0, "httpStatusCode": 200}	5874e173-62fc-487e-ac0d-fb871421dcdd	\N	{}
a9088998-d836-4c05-91ff-4be7e736419c	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--je--1-4_1748352917952.webm	\N	2025-05-27 13:35:18.302815+00	2025-05-27 13:35:18.302815+00	2025-05-27 13:35:18.302815+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:35:19.000Z", "contentLength": 0, "httpStatusCode": 200}	379e3b8d-9288-499a-a331-070891936d07	\N	{}
934d4bc8-c1fd-49cc-b09b-9c8838e77dd6	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--je--1-4_1748352924028.webm	\N	2025-05-27 13:35:24.643873+00	2025-05-27 13:35:24.643873+00	2025-05-27 13:35:24.643873+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:35:25.000Z", "contentLength": 0, "httpStatusCode": 200}	dda8d163-5940-4b49-a891-2bb3dfa7dda6	\N	{}
a2ca7ae8-a65e-4305-945f-8fe8b0526e47	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--t--1-25_1748352987402.webm	\N	2025-05-27 13:36:27.820157+00	2025-05-27 13:36:27.820157+00	2025-05-27 13:36:27.820157+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:36:28.000Z", "contentLength": 0, "httpStatusCode": 200}	d8a28f01-c2e2-447b-add6-4c98aa7cb4c6	\N	{}
8c4aa376-ce0d-4aa5-b90a-bc2b7dc05231	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--1-24_1748352781879.webm	\N	2025-05-27 13:33:02.321507+00	2025-05-27 13:33:02.321507+00	2025-05-27 13:33:02.321507+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:33:03.000Z", "contentLength": 0, "httpStatusCode": 200}	072eca56-1ec5-41c7-9758-158e91593c8e	\N	{}
acead993-391f-4ed6-ad4b-3319c9957578	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--je--1-3_1748352863033.webm	\N	2025-05-27 13:34:23.328578+00	2025-05-27 13:34:23.328578+00	2025-05-27 13:34:23.328578+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:34:24.000Z", "contentLength": 0, "httpStatusCode": 200}	d4feb259-3131-420a-899f-096479c37bb2	\N	{}
838c36b1-c538-4bee-a091-81dd023c93e3	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-2_1748401268003.webm	\N	2025-05-28 03:01:08.205135+00	2025-05-28 03:01:08.205135+00	2025-05-28 03:01:08.205135+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T03:01:09.000Z", "contentLength": 0, "httpStatusCode": 200}	616a1dbb-6d52-4c1d-a9e2-052f693e83f9	\N	{}
9c72c7a3-7c9d-4d6f-b089-141a5e8b6311	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--je--1-3_1748352872794.webm	\N	2025-05-27 13:34:33.125578+00	2025-05-27 13:34:33.125578+00	2025-05-27 13:34:33.125578+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:34:34.000Z", "contentLength": 0, "httpStatusCode": 200}	b2e172a5-733b-4e00-988d-acc1e0c5415b	\N	{}
a7c1cca8-d03b-4d3d-b58d-e3d6e295392a	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-2_1748401273540.webm	\N	2025-05-28 03:01:13.747348+00	2025-05-28 03:01:13.747348+00	2025-05-28 03:01:13.747348+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T03:01:14.000Z", "contentLength": 0, "httpStatusCode": 200}	809aff72-11ea-47bd-b402-344011ac43c6	\N	{}
6fb11a46-9268-4ee1-9c40-96310015b041	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--je--1-3_1748352874197.webm	\N	2025-05-27 13:34:34.632261+00	2025-05-27 13:34:34.632261+00	2025-05-27 13:34:34.632261+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:34:35.000Z", "contentLength": 0, "httpStatusCode": 200}	34ab1569-5c43-4380-bbf0-c2f2d04632b0	\N	{}
0a7158da-fd4a-43c9-9b77-0cee6bc2c8b0	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--je--1-3_1748352874211.webm	\N	2025-05-27 13:34:34.638879+00	2025-05-27 13:34:34.638879+00	2025-05-27 13:34:34.638879+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:34:35.000Z", "contentLength": 0, "httpStatusCode": 200}	47c2e815-51b5-433e-b702-fc5445afe482	\N	{}
aa4128de-5f0a-4ae2-94f7-2f0b8af25bcd	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--je--1-4_1748352924308.webm	\N	2025-05-27 13:35:24.692849+00	2025-05-27 13:35:24.692849+00	2025-05-27 13:35:24.692849+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:35:25.000Z", "contentLength": 0, "httpStatusCode": 200}	92fd0935-8f73-43a7-b3ac-d59840b2d177	\N	{}
24335613-8cbd-44a7-aa76-3e805f99d6a3	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--t--1-25_1748352987513.webm	\N	2025-05-27 13:36:27.831219+00	2025-05-27 13:36:27.831219+00	2025-05-27 13:36:27.831219+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:36:28.000Z", "contentLength": 0, "httpStatusCode": 200}	e7c49fbc-5a6e-4e42-b367-fb8d6cebb869	\N	{}
fe361c25-2b83-4dcc-9dcd-c513f0a88d79	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-2_1748401273917.webm	\N	2025-05-28 03:01:14.097101+00	2025-05-28 03:01:14.097101+00	2025-05-28 03:01:14.097101+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T03:01:15.000Z", "contentLength": 0, "httpStatusCode": 200}	b36f9201-eeed-4e92-8fd3-83a1b4ca9cef	\N	{}
800c37a9-76d9-4802-a2e0-873301256b35	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--t--1-26_1748352994909.webm	\N	2025-05-27 13:36:35.315665+00	2025-05-27 13:36:35.315665+00	2025-05-27 13:36:35.315665+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:36:36.000Z", "contentLength": 0, "httpStatusCode": 200}	9a73d005-3d14-47db-86f6-fd6b658bc3d0	\N	{}
755c2458-7dce-46af-9170-c83eaada8f38	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--t--1-27_1748353022812.webm	\N	2025-05-27 13:37:03.266052+00	2025-05-27 13:37:03.266052+00	2025-05-27 13:37:03.266052+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:37:04.000Z", "contentLength": 0, "httpStatusCode": 200}	a6da3371-01f9-4a03-b17f-057240e6552a	\N	{}
94affafd-53d5-42df-96b4-83d70dc6f46b	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--t--1-27_1748353023405.webm	\N	2025-05-27 13:37:03.697989+00	2025-05-27 13:37:03.697989+00	2025-05-27 13:37:03.697989+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:37:04.000Z", "contentLength": 0, "httpStatusCode": 200}	5ad059ce-c048-4459-b5e3-815b52b7b5e2	\N	{}
62cedf12-034d-4556-8935-60150cc2968f	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--t--1-27_1748353023684.webm	\N	2025-05-27 13:37:03.960696+00	2025-05-27 13:37:03.960696+00	2025-05-27 13:37:03.960696+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:37:04.000Z", "contentLength": 0, "httpStatusCode": 200}	f394c1fa-1bc4-4ffe-930b-f139dcf8dc5f	\N	{}
e28ca5af-b57a-49f4-afe0-d6d271884b5c	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--t--1-28_1748353031565.webm	\N	2025-05-27 13:37:11.912877+00	2025-05-27 13:37:11.912877+00	2025-05-27 13:37:11.912877+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:37:12.000Z", "contentLength": 0, "httpStatusCode": 200}	9dcc1620-ae13-4aec-815c-759d6484824c	\N	{}
3fd231d8-0f4c-47cf-ba9f-decdcd442c07	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-2_1748401273901.webm	\N	2025-05-28 03:01:14.086668+00	2025-05-28 03:01:14.086668+00	2025-05-28 03:01:14.086668+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T03:01:15.000Z", "contentLength": 0, "httpStatusCode": 200}	9edf6c52-e45e-4afe-9c83-b399c014c16a	\N	{}
2e79499e-100d-4d5c-b48b-c7be16d920cc	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--t--1-28_1748353032735.webm	\N	2025-05-27 13:37:13.083849+00	2025-05-27 13:37:13.083849+00	2025-05-27 13:37:13.083849+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:37:14.000Z", "contentLength": 0, "httpStatusCode": 200}	14f8bf6e-abef-4416-9f18-9997838577ec	\N	{}
3d259dac-3e8c-4feb-a558-f54f85934c87	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--t--1-28_1748353033319.webm	\N	2025-05-27 13:37:13.583665+00	2025-05-27 13:37:13.583665+00	2025-05-27 13:37:13.583665+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:37:14.000Z", "contentLength": 0, "httpStatusCode": 200}	e48b0e74-d36c-4dd3-b221-7ae050165e07	\N	{}
b6242261-22f5-4554-922d-17f46fd7864a	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-4_1748401944512.webm	\N	2025-05-28 03:12:24.720421+00	2025-05-28 03:12:24.720421+00	2025-05-28 03:12:24.720421+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T03:12:25.000Z", "contentLength": 0, "httpStatusCode": 200}	a1fd1df0-fa9d-44db-a90b-c3191d554d6e	\N	{}
309737f3-35b8-4b62-a373-6751100f9a23	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--t--1-28_1748353034323.webm	\N	2025-05-27 13:37:14.60795+00	2025-05-27 13:37:14.60795+00	2025-05-27 13:37:14.60795+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:37:15.000Z", "contentLength": 0, "httpStatusCode": 200}	e8d9b4bf-a72e-4beb-aba4-aa0d30466d89	\N	{}
cbe5c454-3f70-45a2-9c5f-2ac96a30b82b	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--t--1-29_1748353044076.webm	\N	2025-05-27 13:37:24.459133+00	2025-05-27 13:37:24.459133+00	2025-05-27 13:37:24.459133+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:37:25.000Z", "contentLength": 0, "httpStatusCode": 200}	75bcf42a-6342-4131-a823-d942feb6ac0d	\N	{}
1e858e2d-e921-4efd-9df2-b593844ce83f	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-4_1748401944804.webm	\N	2025-05-28 03:12:24.971388+00	2025-05-28 03:12:24.971388+00	2025-05-28 03:12:24.971388+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T03:12:25.000Z", "contentLength": 0, "httpStatusCode": 200}	1bb5ff34-67cd-4f3f-8a0a-8e9c9fd72481	\N	{}
9926bbf9-81e3-48aa-88ff-9006f74ecd55	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--t--1-29_1748353044309.webm	\N	2025-05-27 13:37:24.591186+00	2025-05-27 13:37:24.591186+00	2025-05-27 13:37:24.591186+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:37:25.000Z", "contentLength": 0, "httpStatusCode": 200}	eca70a3f-d309-40d7-8351-7eb43170057d	\N	{}
d9f6588b-2ca7-4a05-b660-a1cf1d86be78	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-5_1748402952303.webm	\N	2025-05-28 03:29:13.796798+00	2025-05-28 03:29:13.796798+00	2025-05-28 03:29:13.796798+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T03:29:14.000Z", "contentLength": 0, "httpStatusCode": 200}	44d4cc18-6c94-4106-a60d-517fa40cd737	\N	{}
b569a4f6-14db-4130-9a19-f1aa836baf03	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--t--1-29_1748353045591.webm	\N	2025-05-27 13:37:25.909335+00	2025-05-27 13:37:25.909335+00	2025-05-27 13:37:25.909335+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:37:26.000Z", "contentLength": 0, "httpStatusCode": 200}	e33d779d-eabc-4e71-8067-b2138c0a3416	\N	{}
0112a26f-c5f8-4bb7-8f5c-0d7b453b8f1a	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--t--1-30_1748353056946.webm	\N	2025-05-27 13:37:37.286801+00	2025-05-27 13:37:37.286801+00	2025-05-27 13:37:37.286801+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:37:38.000Z", "contentLength": 0, "httpStatusCode": 200}	6d966d15-f54c-40a9-9b56-b0a2f0451a53	\N	{}
c8053ac7-0266-4fa9-9d64-d9b41c21fe38	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--t--1-29_1748353045660.webm	\N	2025-05-27 13:37:26.025733+00	2025-05-27 13:37:26.025733+00	2025-05-27 13:37:26.025733+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:37:26.000Z", "contentLength": 0, "httpStatusCode": 200}	e943580a-bcb9-4e68-8be1-f45ad62f1408	\N	{}
b8946d54-3f9c-437a-9c2b-bcd583dabfbb	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--t--1-30_1748353055412.webm	\N	2025-05-27 13:37:35.781567+00	2025-05-27 13:37:35.781567+00	2025-05-27 13:37:35.781567+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:37:36.000Z", "contentLength": 0, "httpStatusCode": 200}	50fa1bdb-dc51-4700-a49c-4328cfc361bb	\N	{}
31c0c040-840d-4a38-b936-81a05d4a5599	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-3_1748401906158.webm	\N	2025-05-28 03:11:46.464148+00	2025-05-28 03:11:46.464148+00	2025-05-28 03:11:46.464148+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T03:11:47.000Z", "contentLength": 0, "httpStatusCode": 200}	1768932a-fea5-44db-8d30-1bf8d36a76d1	\N	{}
dd6c1c68-6552-4c55-9904-070b332abbe6	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--t--1-30_1748353056168.webm	\N	2025-05-27 13:37:36.444649+00	2025-05-27 13:37:36.444649+00	2025-05-27 13:37:36.444649+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:37:37.000Z", "contentLength": 0, "httpStatusCode": 200}	7d4f5424-4b3c-4b05-ab40-f6c02673b739	\N	{}
51e18c4a-8807-4ebf-9839-2c9f69c8ab9f	video-chunks	chunks/fb6b83d8-1528-440a-851a-2ef159b28b65--t--1-30_1748353056948.webm	\N	2025-05-27 13:37:37.283631+00	2025-05-27 13:37:37.283631+00	2025-05-27 13:37:37.283631+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-27T13:37:38.000Z", "contentLength": 0, "httpStatusCode": 200}	7f70c5da-0be2-43d9-a291-46f0ede92509	\N	{}
602e362c-bd90-4e14-b31e-6a3e47b50f5c	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-4_1748401944787.webm	\N	2025-05-28 03:12:25.181604+00	2025-05-28 03:12:25.181604+00	2025-05-28 03:12:25.181604+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T03:12:26.000Z", "contentLength": 0, "httpStatusCode": 200}	76d07454-38f4-4dae-b156-2af191915071	\N	{}
2cdca526-3b5e-4509-b0db-ff449c654ad2	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-5_1748402952312.webm	\N	2025-05-28 03:29:13.81089+00	2025-05-28 03:29:13.81089+00	2025-05-28 03:29:13.81089+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T03:29:14.000Z", "contentLength": 0, "httpStatusCode": 200}	a7368cae-9ee6-4a57-8d84-d78b0cc38ff9	\N	{}
96af75bb-52f5-4ec8-bbb4-3d342934efe9	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-6_1748402981417.webm	\N	2025-05-28 03:29:41.661565+00	2025-05-28 03:29:41.661565+00	2025-05-28 03:29:41.661565+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T03:29:42.000Z", "contentLength": 0, "httpStatusCode": 200}	fb6f6ab6-e021-4a41-8279-15d3647f672b	\N	{}
ff1ecfa6-b813-42c4-be30-a56812195a44	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-6_1748402984346.webm	\N	2025-05-28 03:29:44.508518+00	2025-05-28 03:29:44.508518+00	2025-05-28 03:29:44.508518+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T03:29:45.000Z", "contentLength": 0, "httpStatusCode": 200}	14206814-e8b9-4178-b7dc-1d670d3a3785	\N	{}
85c82001-7d82-4b9d-b100-176afabd0f97	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-6_1748402984619.webm	\N	2025-05-28 03:29:44.779331+00	2025-05-28 03:29:44.779331+00	2025-05-28 03:29:44.779331+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T03:29:45.000Z", "contentLength": 0, "httpStatusCode": 200}	93a63f00-9a0f-4874-9de7-d0c5d7eb7ac0	\N	{}
f54ea415-ab2f-460c-b075-10fb026cdd6b	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-8_1748403622675.webm	\N	2025-05-28 03:40:22.816178+00	2025-05-28 03:40:22.816178+00	2025-05-28 03:40:22.816178+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T03:40:23.000Z", "contentLength": 0, "httpStatusCode": 200}	229a4243-b30b-46cc-9a0a-f3226b06c469	\N	{}
759f30d6-03a7-43c3-86b5-e6f2de6672f1	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-1_1748403711231.webm	\N	2025-05-28 03:41:51.521604+00	2025-05-28 03:41:51.521604+00	2025-05-28 03:41:51.521604+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T03:41:52.000Z", "contentLength": 0, "httpStatusCode": 200}	229a1014-ae91-4ea4-af34-a0d6ad759218	\N	{}
74ec321b-0822-4801-a29c-63054f378444	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-2_1748407865948.webm	\N	2025-05-28 04:51:06.200342+00	2025-05-28 04:51:06.200342+00	2025-05-28 04:51:06.200342+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T04:51:07.000Z", "contentLength": 0, "httpStatusCode": 200}	8eca3b8c-8a33-4035-b47d-58a599761262	\N	{}
75a06407-df56-450b-99ae-e23320557c06	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-2_1748407869022.webm	\N	2025-05-28 04:51:09.268096+00	2025-05-28 04:51:09.268096+00	2025-05-28 04:51:09.268096+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T04:51:10.000Z", "contentLength": 0, "httpStatusCode": 200}	ab1d50b4-f301-493d-b2e6-40db69bb93a0	\N	{}
449569d2-472e-41ed-a256-0d38cb0a4d1f	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-2_1748407869115.webm	\N	2025-05-28 04:51:09.372187+00	2025-05-28 04:51:09.372187+00	2025-05-28 04:51:09.372187+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T04:51:10.000Z", "contentLength": 0, "httpStatusCode": 200}	5d0ef3f3-5d58-4bee-8516-8b820890b701	\N	{}
31c768b8-1b06-4c91-b38f-661b0dea9f4f	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-3_1748407913537.webm	\N	2025-05-28 04:51:53.794299+00	2025-05-28 04:51:53.794299+00	2025-05-28 04:51:53.794299+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T04:51:54.000Z", "contentLength": 0, "httpStatusCode": 200}	23671426-2fea-4745-82ad-ebf8ddaaf8d5	\N	{}
2b5abf1e-d5b6-4b76-a993-6d1e32005d26	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-3_1748407914408.webm	\N	2025-05-28 04:51:54.572206+00	2025-05-28 04:51:54.572206+00	2025-05-28 04:51:54.572206+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T04:51:55.000Z", "contentLength": 0, "httpStatusCode": 200}	b321ee8c-6423-4bee-be98-f5d766e8801c	\N	{}
fb23a91c-c9b0-4edb-952a-9e122ff84192	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-3_1748407915379.webm	\N	2025-05-28 04:51:55.548578+00	2025-05-28 04:51:55.548578+00	2025-05-28 04:51:55.548578+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T04:51:56.000Z", "contentLength": 0, "httpStatusCode": 200}	88fae894-62f1-422c-8f6a-1285fd08ad87	\N	{}
c735f519-144f-4284-b051-ad9fa2eb4a96	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-1_1748409403733.webm	\N	2025-05-28 05:16:43.966802+00	2025-05-28 05:16:43.966802+00	2025-05-28 05:16:43.966802+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T05:16:44.000Z", "contentLength": 0, "httpStatusCode": 200}	c4106d68-8498-47d8-9e60-cf7b05101979	\N	{}
ba100a2d-9ab7-4362-99f4-2e348b0648eb	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-1_1748409407317.webm	\N	2025-05-28 05:16:47.509983+00	2025-05-28 05:16:47.509983+00	2025-05-28 05:16:47.509983+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T05:16:48.000Z", "contentLength": 0, "httpStatusCode": 200}	31255d21-154e-4968-8e52-caf8347f4ca2	\N	{}
741aec3a-823a-48a0-8844-a9e5b7d67f65	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-1_1748409408236.webm	\N	2025-05-28 05:16:48.417558+00	2025-05-28 05:16:48.417558+00	2025-05-28 05:16:48.417558+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T05:16:49.000Z", "contentLength": 0, "httpStatusCode": 200}	e8ebc868-d8be-408a-bd88-4058446202ac	\N	{}
80e8559f-08ae-40d1-9167-38c119b6ca95	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-1_1748409408096.webm	\N	2025-05-28 05:16:48.434655+00	2025-05-28 05:16:48.434655+00	2025-05-28 05:16:48.434655+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T05:16:49.000Z", "contentLength": 0, "httpStatusCode": 200}	545abd17-c8d4-4920-8009-83a678a0d4fd	\N	{}
9e269c69-9dfc-4c68-bf2e-f632c5f60b2b	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-2_1748409430876.webm	\N	2025-05-28 05:17:11.119152+00	2025-05-28 05:17:11.119152+00	2025-05-28 05:17:11.119152+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T05:17:12.000Z", "contentLength": 0, "httpStatusCode": 200}	f7da8844-2271-4f99-8a32-7033873e1045	\N	{}
af0a8931-cd64-4cfc-9a47-cde35bb75835	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-2_1748409433018.webm	\N	2025-05-28 05:17:13.228152+00	2025-05-28 05:17:13.228152+00	2025-05-28 05:17:13.228152+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T05:17:14.000Z", "contentLength": 0, "httpStatusCode": 200}	c476b036-30eb-4f23-bf89-3cd887bb5a24	\N	{}
3e74a4ce-dcdd-4610-abbd-7f329c82cf69	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-2_1748409434364.webm	\N	2025-05-28 05:17:14.546466+00	2025-05-28 05:17:14.546466+00	2025-05-28 05:17:14.546466+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T05:17:15.000Z", "contentLength": 0, "httpStatusCode": 200}	5c9b0d05-128a-440f-b012-f09d7c9a35d9	\N	{}
165b0321-5443-4558-bb7a-ce57a8f0a64f	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-3_1748410409835.webm	\N	2025-05-28 05:33:30.071208+00	2025-05-28 05:33:30.071208+00	2025-05-28 05:33:30.071208+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T05:33:31.000Z", "contentLength": 0, "httpStatusCode": 200}	e5c64a27-ac3d-40e8-91f7-928bb3e492ca	\N	{}
0e8389bd-3f91-4696-b216-f0e4ce59655f	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-3_1748410424824.webm	\N	2025-05-28 05:33:45.097187+00	2025-05-28 05:33:45.097187+00	2025-05-28 05:33:45.097187+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T05:33:46.000Z", "contentLength": 0, "httpStatusCode": 200}	7bd4cd57-88cb-4960-b579-9dcde3706f2f	\N	{}
4b9b1843-d956-4104-80d6-b2ba2039f3d1	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-3_1748410424832.webm	\N	2025-05-28 05:33:45.105423+00	2025-05-28 05:33:45.105423+00	2025-05-28 05:33:45.105423+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T05:33:46.000Z", "contentLength": 0, "httpStatusCode": 200}	e377bdbc-86b6-49f1-b1b9-2e17734b430e	\N	{}
e684e312-6d6e-4904-ba55-d5d0555b421a	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-4_1748410464193.webm	\N	2025-05-28 05:34:24.486977+00	2025-05-28 05:34:24.486977+00	2025-05-28 05:34:24.486977+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T05:34:25.000Z", "contentLength": 0, "httpStatusCode": 200}	84add5ff-f207-4c3e-a8de-9ff758daca15	\N	{}
58e3d1eb-64df-4989-92e0-45ec7209bcd2	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-4_1748410476092.webm	\N	2025-05-28 05:34:36.340177+00	2025-05-28 05:34:36.340177+00	2025-05-28 05:34:36.340177+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T05:34:37.000Z", "contentLength": 0, "httpStatusCode": 200}	c2738203-2a93-4b37-93ea-3da16ba3ee78	\N	{}
6e8acdce-6bc9-42f3-ac50-16cc76d4d8fa	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-4_1748410476086.webm	\N	2025-05-28 05:34:36.342196+00	2025-05-28 05:34:36.342196+00	2025-05-28 05:34:36.342196+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T05:34:37.000Z", "contentLength": 0, "httpStatusCode": 200}	194542a3-9877-4405-9d04-59d8dea484a5	\N	{}
cbd4e2f1-5ec2-4f54-82d9-7eb7e48e46b8	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-4_1748410476130.webm	\N	2025-05-28 05:34:36.348485+00	2025-05-28 05:34:36.348485+00	2025-05-28 05:34:36.348485+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T05:34:37.000Z", "contentLength": 0, "httpStatusCode": 200}	588a6696-3ad2-4dec-8dcf-8f61fca903fc	\N	{}
c233bbb5-fd18-4e4c-82a4-fd61abac1d51	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--john--3456789-1_1748410967850.webm	\N	2025-05-28 05:42:48.888631+00	2025-05-28 05:42:48.888631+00	2025-05-28 05:42:48.888631+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T05:42:49.000Z", "contentLength": 0, "httpStatusCode": 200}	b0fbcb59-bebd-4d2e-acd2-5f375a47f4b9	\N	{}
ba33e55d-322e-41ba-b2a3-d5994e4e1705	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--john--3456789-1_1748410967843.webm	\N	2025-05-28 05:42:48.88474+00	2025-05-28 05:42:48.88474+00	2025-05-28 05:42:48.88474+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T05:42:49.000Z", "contentLength": 0, "httpStatusCode": 200}	2694c3e4-caac-464b-8081-c54a56ce201a	\N	{}
1dfe57e3-32be-4df2-bfd7-5b0b46eff1ee	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--john--3456789-1_1748410967856.webm	\N	2025-05-28 05:42:48.883891+00	2025-05-28 05:42:48.883891+00	2025-05-28 05:42:48.883891+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T05:42:49.000Z", "contentLength": 0, "httpStatusCode": 200}	b12d2055-f170-44df-95df-9a5ac4073471	\N	{}
964a6450-f00b-47d9-8c3a-da7d9db0824e	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--testing--7878-1_1748411927109.webm	\N	2025-05-28 05:58:47.321552+00	2025-05-28 05:58:47.321552+00	2025-05-28 05:58:47.321552+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T05:58:48.000Z", "contentLength": 0, "httpStatusCode": 200}	1195416c-99ea-4fa0-81c8-80e7bd180985	\N	{}
d24d5580-ade4-468b-ae73-f36154b86ac3	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--testing--7878-1_1748411927205.webm	\N	2025-05-28 05:58:47.403452+00	2025-05-28 05:58:47.403452+00	2025-05-28 05:58:47.403452+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T05:58:48.000Z", "contentLength": 0, "httpStatusCode": 200}	8ca55536-9373-4639-81ed-0615dbf0f8f7	\N	{}
1aba2e79-0f7c-4909-bd11-4b6df427e140	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--testing--7878-1_1748411927131.webm	\N	2025-05-28 05:58:47.337422+00	2025-05-28 05:58:47.337422+00	2025-05-28 05:58:47.337422+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T05:58:48.000Z", "contentLength": 0, "httpStatusCode": 200}	56c89ebb-7931-48dc-acac-d8e99bbc1b00	\N	{}
ced1a5ae-25fc-4a86-821b-881dbbbae5d6	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-1_1748414857640.webm	\N	2025-05-28 06:47:37.892076+00	2025-05-28 06:47:37.892076+00	2025-05-28 06:47:37.892076+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T06:47:38.000Z", "contentLength": 0, "httpStatusCode": 200}	422751f7-2086-4825-b519-37ab7a97b5c9	\N	{}
a9ba836e-da5d-4c23-8680-a008151bb856	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-1_1748414858015.webm	\N	2025-05-28 06:47:38.228074+00	2025-05-28 06:47:38.228074+00	2025-05-28 06:47:38.228074+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T06:47:39.000Z", "contentLength": 0, "httpStatusCode": 200}	741b98d3-d949-4032-9ba8-7c5de1338778	\N	{}
2544cce7-5601-451a-9368-2ee6616a26c8	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-1_1748414861568.webm	\N	2025-05-28 06:47:41.736715+00	2025-05-28 06:47:41.736715+00	2025-05-28 06:47:41.736715+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T06:47:42.000Z", "contentLength": 0, "httpStatusCode": 200}	17d0c368-1c18-439e-aab4-72cf86dbc58f	\N	{}
254f1588-1c1d-4170-99cd-29173e4717db	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-2_1748414951841.webm	\N	2025-05-28 06:49:12.126281+00	2025-05-28 06:49:12.126281+00	2025-05-28 06:49:12.126281+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T06:49:13.000Z", "contentLength": 0, "httpStatusCode": 200}	923bc094-7ae4-4031-b9f1-3beacfc9de99	\N	{}
3320d790-09cf-4df6-b811-781504add5bd	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-2_1748414953072.webm	\N	2025-05-28 06:49:13.248254+00	2025-05-28 06:49:13.248254+00	2025-05-28 06:49:13.248254+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T06:49:14.000Z", "contentLength": 0, "httpStatusCode": 200}	42eb24d5-15ff-4371-bac5-5c4859d3d3c3	\N	{}
64201c99-3458-4100-afeb-9e8f9e4dc66e	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-2_1748414959330.webm	\N	2025-05-28 06:49:19.546426+00	2025-05-28 06:49:19.546426+00	2025-05-28 06:49:19.546426+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T06:49:20.000Z", "contentLength": 0, "httpStatusCode": 200}	ec86af2f-fc3a-4fb8-b782-6e47632024e8	\N	{}
899c02bb-ad0c-4baa-87b3-23857caa2aab	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-2_1748414959448.webm	\N	2025-05-28 06:49:19.631365+00	2025-05-28 06:49:19.631365+00	2025-05-28 06:49:19.631365+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T06:49:20.000Z", "contentLength": 0, "httpStatusCode": 200}	394df917-a7de-4eaf-8ee5-bc36f10a1f6f	\N	{}
f5af4bf5-75a4-4829-9411-30452901c636	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-2_1748414960506.webm	\N	2025-05-28 06:49:20.677843+00	2025-05-28 06:49:20.677843+00	2025-05-28 06:49:20.677843+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T06:49:21.000Z", "contentLength": 0, "httpStatusCode": 200}	69a3bdac-8643-4913-bdca-1ec0ed3d7d4e	\N	{}
7f24d013-12d9-4856-87ff-c882886207ef	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--Koh Jing En--1-2_1748414960555.webm	\N	2025-05-28 06:49:20.738582+00	2025-05-28 06:49:20.738582+00	2025-05-28 06:49:20.738582+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-05-28T06:49:21.000Z", "contentLength": 0, "httpStatusCode": 200}	3fe90108-71ed-4bce-a639-f246576102b4	\N	{}
38eb4ac3-ba50-4828-86ea-3f5565f55676	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-1_1748768888357.webm	\N	2025-06-01 09:08:13.167982+00	2025-06-01 09:08:13.167982+00	2025-06-01 09:08:13.167982+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-06-01T09:08:14.000Z", "contentLength": 0, "httpStatusCode": 200}	5a87b1d2-7319-4a54-8dc3-d9543e8cbb3f	\N	{}
5a82eafe-0ddc-4329-bba6-491fbb677b9d	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-1_1748768888312.webm	\N	2025-06-01 09:08:13.1632+00	2025-06-01 09:08:13.1632+00	2025-06-01 09:08:13.1632+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-06-01T09:08:14.000Z", "contentLength": 0, "httpStatusCode": 200}	da864593-c11c-470f-8930-cfacd941b06f	\N	{}
8129d87e-db51-477f-803f-900f9fdb7a3a	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-1_1748768888327.webm	\N	2025-06-01 09:08:13.36134+00	2025-06-01 09:08:13.36134+00	2025-06-01 09:08:13.36134+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-06-01T09:08:14.000Z", "contentLength": 0, "httpStatusCode": 200}	696ba1d3-5290-4805-841a-6f4b176f6157	\N	{}
2637f1ed-d0b3-47c7-b35c-6e4a5880fe7d	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-1_1748768890541.webm	\N	2025-06-01 09:08:15.931801+00	2025-06-01 09:08:15.931801+00	2025-06-01 09:08:15.931801+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-06-01T09:08:16.000Z", "contentLength": 0, "httpStatusCode": 200}	76b6ac5b-e60d-49de-8970-ae75d198f0ae	\N	{}
0feb0db1-d970-44cd-aec5-b475bcc26703	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-1_1748768912949.webm	\N	2025-06-01 09:08:33.31986+00	2025-06-01 09:08:33.31986+00	2025-06-01 09:08:33.31986+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-06-01T09:08:34.000Z", "contentLength": 0, "httpStatusCode": 200}	49a0e561-c62d-4fc6-9627-3e2afc535162	\N	{}
592b09c4-9614-40a9-a0e9-6167b121f4be	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-1_1748768914717.webm	\N	2025-06-01 09:08:34.987654+00	2025-06-01 09:08:34.987654+00	2025-06-01 09:08:34.987654+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-06-01T09:08:35.000Z", "contentLength": 0, "httpStatusCode": 200}	c49fe42c-0d75-4a5f-9275-684544de804c	\N	{}
d543da64-1e67-4d61-85cf-67dfab9c19d2	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-1_1748768926232.webm	\N	2025-06-01 09:08:46.638662+00	2025-06-01 09:08:46.638662+00	2025-06-01 09:08:46.638662+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-06-01T09:08:47.000Z", "contentLength": 0, "httpStatusCode": 200}	997292e8-019b-4a03-83ae-10f0c6c2bee5	\N	{}
e2437cc4-cc31-46bc-af1c-1b869727ba36	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-1_1748768926712.webm	\N	2025-06-01 09:08:46.97093+00	2025-06-01 09:08:46.97093+00	2025-06-01 09:08:46.97093+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-06-01T09:08:47.000Z", "contentLength": 0, "httpStatusCode": 200}	aff398f9-0a0f-4c8d-a626-c02aa40dcd35	\N	{}
253b8076-d59d-49ab-8fbb-e4a6d6b4d715	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-1_1748768926842.webm	\N	2025-06-01 09:08:47.085273+00	2025-06-01 09:08:47.085273+00	2025-06-01 09:08:47.085273+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-06-01T09:08:48.000Z", "contentLength": 0, "httpStatusCode": 200}	564c1b5f-71ff-4043-9867-478c38661bb1	\N	{}
e414dc91-765c-44b3-bf9a-c549a91de682	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-1_1748768971283.webm	\N	2025-06-01 09:09:31.692433+00	2025-06-01 09:09:31.692433+00	2025-06-01 09:09:31.692433+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-06-01T09:09:32.000Z", "contentLength": 0, "httpStatusCode": 200}	dab6ccc7-451c-457e-89a2-bb7804727653	\N	{}
bec5e8b3-a1c4-4447-ac88-57edf0177628	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-1_1748768972207.webm	\N	2025-06-01 09:09:32.491636+00	2025-06-01 09:09:32.491636+00	2025-06-01 09:09:32.491636+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-06-01T09:09:33.000Z", "contentLength": 0, "httpStatusCode": 200}	35583406-ca72-483a-9d11-8e784fe047ae	\N	{}
99a54c2c-4e27-442c-a7bb-20e39eb7fde4	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-1_1748768973616.webm	\N	2025-06-01 09:09:33.856321+00	2025-06-01 09:09:33.856321+00	2025-06-01 09:09:33.856321+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-06-01T09:09:34.000Z", "contentLength": 0, "httpStatusCode": 200}	738579a0-662a-4979-a926-22b8004c96f6	\N	{}
9b9624f8-5065-420c-b4e5-99da2a43406e	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-1_1748768975219.webm	\N	2025-06-01 09:09:35.47652+00	2025-06-01 09:09:35.47652+00	2025-06-01 09:09:35.47652+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-06-01T09:09:36.000Z", "contentLength": 0, "httpStatusCode": 200}	763e3b69-ae0e-4161-a3bb-70f2f378563f	\N	{}
f68ea0cb-56bf-4642-b7c2-25a30eff5cb6	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-2_1748768998220.webm	\N	2025-06-01 09:09:58.707483+00	2025-06-01 09:09:58.707483+00	2025-06-01 09:09:58.707483+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-06-01T09:09:59.000Z", "contentLength": 0, "httpStatusCode": 200}	1865b1b6-844a-49f3-9c86-1ebc3a4cbbd1	\N	{}
bafddd4c-590a-4198-ad75-9bd68ddd2e23	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-2_1748769001193.webm	\N	2025-06-01 09:10:01.636553+00	2025-06-01 09:10:01.636553+00	2025-06-01 09:10:01.636553+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-06-01T09:10:02.000Z", "contentLength": 0, "httpStatusCode": 200}	696c84b7-2dce-485d-a7f5-587e5ffeb3d8	\N	{}
5af6fe63-1411-45cb-9f9c-122a794728db	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-1_1748768926702.webm	\N	2025-06-01 09:08:46.962005+00	2025-06-01 09:08:46.962005+00	2025-06-01 09:08:46.962005+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-06-01T09:08:47.000Z", "contentLength": 0, "httpStatusCode": 200}	e6192a52-f900-4fc8-9db7-5ced23c398fd	\N	{}
f8d62e4f-a524-4e03-915f-a1b8a8509ab5	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-2_1748769005468.webm	\N	2025-06-01 09:10:05.763595+00	2025-06-01 09:10:05.763595+00	2025-06-01 09:10:05.763595+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-06-01T09:10:06.000Z", "contentLength": 0, "httpStatusCode": 200}	1bd16b8b-b449-4246-9834-b1e78a21252d	\N	{}
2671eb92-3943-497c-bf64-6ab80187e607	video-chunks	chunks/ba5e41c4-8085-4d08-a656-faca201d6ba3--tt--0-2_1748769005321.webm	\N	2025-06-01 09:10:05.800695+00	2025-06-01 09:10:05.800695+00	2025-06-01 09:10:05.800695+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "video/webm", "cacheControl": "no-cache", "lastModified": "2025-06-01T09:10:06.000Z", "contentLength": 0, "httpStatusCode": 200}	30b7b6bc-0f5f-4fe8-9e44-41239b23b5b0	\N	{}
\.


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: supabase_admin
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 156, true);


--
-- Name: analyzed_subject_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.analyzed_subject_id_seq', 156, true);


--
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: supabase_admin
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1, false);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: user User_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);


--
-- Name: analyzed_subject analyzed_subject_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.analyzed_subject
    ADD CONSTRAINT analyzed_subject_pkey PRIMARY KEY (id);


--
-- Name: analyzed_subject analyzed_subject_session_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.analyzed_subject
    ADD CONSTRAINT analyzed_subject_session_id_key UNIQUE (session_id);


--
-- Name: session_video session_video_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session_video
    ADD CONSTRAINT session_video_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- Name: subscription_subscription_id_entity_filters_key; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_key ON realtime.subscription USING btree (subscription_id, entity, filters);


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: supabase_admin
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: user User_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT "User_id_fkey" FOREIGN KEY (id) REFERENCES auth.users(id);


--
-- Name: analyzed_subject analyzed_subject_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.analyzed_subject
    ADD CONSTRAINT analyzed_subject_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: session_video fk_session_video_subject; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session_video
    ADD CONSTRAINT fk_session_video_subject FOREIGN KEY (subject_id) REFERENCES public.analyzed_subject(id) ON DELETE CASCADE;


--
-- Name: session_video session_video_subject_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session_video
    ADD CONSTRAINT session_video_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES public.analyzed_subject(id);


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- Name: user Allow user to update their own row; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow user to update their own row" ON public."user" FOR UPDATE USING ((auth.uid() = id));


--
-- Name: user Insert own user profile; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Insert own user profile" ON public."user" FOR INSERT WITH CHECK ((auth.uid() = id));


--
-- Name: analyzed_subject User can read own data; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "User can read own data" ON public.analyzed_subject FOR SELECT USING ((user_id = auth.uid()));


--
-- Name: user Users can read their own data; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can read their own data" ON public."user" FOR SELECT USING ((auth.uid() = id));


--
-- Name: analyzed_subject; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.analyzed_subject ENABLE ROW LEVEL SECURITY;

--
-- Name: session_video; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.session_video ENABLE ROW LEVEL SECURITY;

--
-- Name: user; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public."user" ENABLE ROW LEVEL SECURITY;

--
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: postgres
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime OWNER TO postgres;

--
-- Name: supabase_realtime user; Type: PUBLICATION TABLE; Schema: public; Owner: postgres
--

ALTER PUBLICATION supabase_realtime ADD TABLE ONLY public."user";


--
-- Name: SCHEMA auth; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA auth TO anon;
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT USAGE ON SCHEMA auth TO service_role;
GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
GRANT ALL ON SCHEMA auth TO dashboard_user;
GRANT USAGE ON SCHEMA auth TO postgres;


--
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA extensions TO anon;
GRANT USAGE ON SCHEMA extensions TO authenticated;
GRANT USAGE ON SCHEMA extensions TO service_role;
GRANT ALL ON SCHEMA extensions TO dashboard_user;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA realtime TO postgres;
GRANT USAGE ON SCHEMA realtime TO anon;
GRANT USAGE ON SCHEMA realtime TO authenticated;
GRANT USAGE ON SCHEMA realtime TO service_role;
GRANT ALL ON SCHEMA realtime TO supabase_realtime_admin;


--
-- Name: SCHEMA storage; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA storage TO postgres;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin;
GRANT ALL ON SCHEMA storage TO dashboard_user;


--
-- Name: SCHEMA vault; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA vault TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA vault TO service_role;


--
-- Name: FUNCTION email(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.email() TO dashboard_user;


--
-- Name: FUNCTION jwt(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.jwt() TO postgres;
GRANT ALL ON FUNCTION auth.jwt() TO dashboard_user;


--
-- Name: FUNCTION role(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.role() TO dashboard_user;


--
-- Name: FUNCTION uid(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.uid() TO dashboard_user;


--
-- Name: FUNCTION algorithm_sign(signables text, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.algorithm_sign(signables text, secret text, algorithm text) FROM postgres;
GRANT ALL ON FUNCTION extensions.algorithm_sign(signables text, secret text, algorithm text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.algorithm_sign(signables text, secret text, algorithm text) TO dashboard_user;


--
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.armor(bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO dashboard_user;


--
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.armor(bytea, text[], text[]) FROM postgres;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO dashboard_user;


--
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.crypt(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.dearmor(text) FROM postgres;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO dashboard_user;


--
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.digest(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.digest(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_random_bytes(integer) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO dashboard_user;


--
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_random_uuid() FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_salt(text) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_salt(text, integer) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO dashboard_user;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_cron_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO dashboard_user;


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.grant_pg_graphql_access() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION grant_pg_net_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_net_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO dashboard_user;


--
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.hmac(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.hmac(text, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_reset(userid oid, dbid oid, queryid bigint); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint) TO dashboard_user;


--
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO dashboard_user;


--
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_key_id(bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgrst_ddl_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_ddl_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgrst_drop_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_drop_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION set_graphql_placeholder(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.set_graphql_placeholder() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION sign(payload json, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.sign(payload json, secret text, algorithm text) FROM postgres;
GRANT ALL ON FUNCTION extensions.sign(payload json, secret text, algorithm text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.sign(payload json, secret text, algorithm text) TO dashboard_user;


--
-- Name: FUNCTION try_cast_double(inp text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.try_cast_double(inp text) FROM postgres;
GRANT ALL ON FUNCTION extensions.try_cast_double(inp text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.try_cast_double(inp text) TO dashboard_user;


--
-- Name: FUNCTION url_decode(data text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.url_decode(data text) FROM postgres;
GRANT ALL ON FUNCTION extensions.url_decode(data text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.url_decode(data text) TO dashboard_user;


--
-- Name: FUNCTION url_encode(data bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.url_encode(data bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.url_encode(data bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.url_encode(data bytea) TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v1(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v1() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v1mc(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v1mc() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v3(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v4(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v4() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v5(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_nil(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_nil() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_dns(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_dns() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_oid(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_oid() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_url(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_url() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_x500(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_x500() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO dashboard_user;


--
-- Name: FUNCTION verify(token text, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.verify(token text, secret text, algorithm text) FROM postgres;
GRANT ALL ON FUNCTION extensions.verify(token text, secret text, algorithm text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.verify(token text, secret text, algorithm text) TO dashboard_user;


--
-- Name: FUNCTION graphql("operationName" text, query text, variables jsonb, extensions jsonb); Type: ACL; Schema: graphql_public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO postgres;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO anon;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO authenticated;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO service_role;


--
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text) FROM PUBLIC;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO pgbouncer;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO postgres;


--
-- Name: FUNCTION apply_rls(wal jsonb, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO supabase_realtime_admin;


--
-- Name: FUNCTION broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO postgres;
GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO dashboard_user;


--
-- Name: FUNCTION build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO postgres;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO anon;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO service_role;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION "cast"(val text, type_ regtype); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO postgres;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO dashboard_user;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO anon;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO authenticated;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO service_role;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO supabase_realtime_admin;


--
-- Name: FUNCTION check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO postgres;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO anon;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO authenticated;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO service_role;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO supabase_realtime_admin;


--
-- Name: FUNCTION is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO postgres;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO anon;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO service_role;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO supabase_realtime_admin;


--
-- Name: FUNCTION quote_wal2json(entity regclass); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO postgres;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO anon;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO authenticated;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO service_role;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO supabase_realtime_admin;


--
-- Name: FUNCTION send(payload jsonb, event text, topic text, private boolean); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO dashboard_user;


--
-- Name: FUNCTION subscription_check_filters(); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO postgres;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO dashboard_user;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO anon;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO authenticated;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO service_role;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO supabase_realtime_admin;


--
-- Name: FUNCTION to_regrole(role_name text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO postgres;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO anon;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO authenticated;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO service_role;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO supabase_realtime_admin;


--
-- Name: FUNCTION topic(); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.topic() TO postgres;
GRANT ALL ON FUNCTION realtime.topic() TO dashboard_user;


--
-- Name: FUNCTION _crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO service_role;


--
-- Name: FUNCTION create_secret(new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: FUNCTION update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: TABLE audit_log_entries; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.audit_log_entries TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.audit_log_entries TO postgres;
GRANT SELECT ON TABLE auth.audit_log_entries TO postgres WITH GRANT OPTION;


--
-- Name: TABLE flow_state; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.flow_state TO postgres;
GRANT SELECT ON TABLE auth.flow_state TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.flow_state TO dashboard_user;


--
-- Name: TABLE identities; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.identities TO postgres;
GRANT SELECT ON TABLE auth.identities TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.identities TO dashboard_user;


--
-- Name: TABLE instances; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.instances TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.instances TO postgres;
GRANT SELECT ON TABLE auth.instances TO postgres WITH GRANT OPTION;


--
-- Name: TABLE mfa_amr_claims; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.mfa_amr_claims TO postgres;
GRANT SELECT ON TABLE auth.mfa_amr_claims TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_amr_claims TO dashboard_user;


--
-- Name: TABLE mfa_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.mfa_challenges TO postgres;
GRANT SELECT ON TABLE auth.mfa_challenges TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_challenges TO dashboard_user;


--
-- Name: TABLE mfa_factors; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.mfa_factors TO postgres;
GRANT SELECT ON TABLE auth.mfa_factors TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_factors TO dashboard_user;


--
-- Name: TABLE one_time_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.one_time_tokens TO postgres;
GRANT SELECT ON TABLE auth.one_time_tokens TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.one_time_tokens TO dashboard_user;


--
-- Name: TABLE refresh_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.refresh_tokens TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.refresh_tokens TO postgres;
GRANT SELECT ON TABLE auth.refresh_tokens TO postgres WITH GRANT OPTION;


--
-- Name: SEQUENCE refresh_tokens_id_seq; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO dashboard_user;
GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO postgres;


--
-- Name: TABLE saml_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.saml_providers TO postgres;
GRANT SELECT ON TABLE auth.saml_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_providers TO dashboard_user;


--
-- Name: TABLE saml_relay_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.saml_relay_states TO postgres;
GRANT SELECT ON TABLE auth.saml_relay_states TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_relay_states TO dashboard_user;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT SELECT ON TABLE auth.schema_migrations TO postgres WITH GRANT OPTION;


--
-- Name: TABLE sessions; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.sessions TO postgres;
GRANT SELECT ON TABLE auth.sessions TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sessions TO dashboard_user;


--
-- Name: TABLE sso_domains; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.sso_domains TO postgres;
GRANT SELECT ON TABLE auth.sso_domains TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_domains TO dashboard_user;


--
-- Name: TABLE sso_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.sso_providers TO postgres;
GRANT SELECT ON TABLE auth.sso_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_providers TO dashboard_user;


--
-- Name: TABLE users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.users TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE auth.users TO postgres;
GRANT SELECT ON TABLE auth.users TO postgres WITH GRANT OPTION;


--
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON TABLE extensions.pg_stat_statements FROM postgres;
GRANT ALL ON TABLE extensions.pg_stat_statements TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements TO dashboard_user;


--
-- Name: TABLE pg_stat_statements_info; Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON TABLE extensions.pg_stat_statements_info FROM postgres;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO dashboard_user;


--
-- Name: TABLE analyzed_subject; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.analyzed_subject TO anon;
GRANT ALL ON TABLE public.analyzed_subject TO authenticated;
GRANT ALL ON TABLE public.analyzed_subject TO service_role;


--
-- Name: SEQUENCE analyzed_subject_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.analyzed_subject_id_seq TO anon;
GRANT ALL ON SEQUENCE public.analyzed_subject_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.analyzed_subject_id_seq TO service_role;


--
-- Name: TABLE session_video; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.session_video TO anon;
GRANT ALL ON TABLE public.session_video TO authenticated;
GRANT ALL ON TABLE public.session_video TO service_role;


--
-- Name: TABLE "user"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public."user" TO anon;
GRANT ALL ON TABLE public."user" TO authenticated;
GRANT ALL ON TABLE public."user" TO service_role;


--
-- Name: TABLE messages; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.messages TO postgres;
GRANT ALL ON TABLE realtime.messages TO dashboard_user;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO anon;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO authenticated;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO service_role;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.schema_migrations TO postgres;
GRANT ALL ON TABLE realtime.schema_migrations TO dashboard_user;
GRANT SELECT ON TABLE realtime.schema_migrations TO anon;
GRANT SELECT ON TABLE realtime.schema_migrations TO authenticated;
GRANT SELECT ON TABLE realtime.schema_migrations TO service_role;
GRANT ALL ON TABLE realtime.schema_migrations TO supabase_realtime_admin;


--
-- Name: TABLE subscription; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.subscription TO postgres;
GRANT ALL ON TABLE realtime.subscription TO dashboard_user;
GRANT SELECT ON TABLE realtime.subscription TO anon;
GRANT SELECT ON TABLE realtime.subscription TO authenticated;
GRANT SELECT ON TABLE realtime.subscription TO service_role;
GRANT ALL ON TABLE realtime.subscription TO supabase_realtime_admin;


--
-- Name: SEQUENCE subscription_id_seq; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO postgres;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO dashboard_user;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO anon;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO authenticated;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO service_role;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO supabase_realtime_admin;


--
-- Name: TABLE buckets; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets TO anon;
GRANT ALL ON TABLE storage.buckets TO authenticated;
GRANT ALL ON TABLE storage.buckets TO service_role;
GRANT ALL ON TABLE storage.buckets TO postgres;


--
-- Name: TABLE objects; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.objects TO anon;
GRANT ALL ON TABLE storage.objects TO authenticated;
GRANT ALL ON TABLE storage.objects TO service_role;
GRANT ALL ON TABLE storage.objects TO postgres;


--
-- Name: TABLE s3_multipart_uploads; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO anon;


--
-- Name: TABLE s3_multipart_uploads_parts; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads_parts TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO anon;


--
-- Name: TABLE secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.secrets TO service_role;


--
-- Name: TABLE decrypted_secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.decrypted_secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.decrypted_secrets TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON SEQUENCES  TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON FUNCTIONS  TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON TABLES  TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES  TO service_role;


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


ALTER EVENT TRIGGER issue_graphql_placeholder OWNER TO supabase_admin;

--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


ALTER EVENT TRIGGER issue_pg_cron_access OWNER TO supabase_admin;

--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


ALTER EVENT TRIGGER issue_pg_graphql_access OWNER TO supabase_admin;

--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


ALTER EVENT TRIGGER issue_pg_net_access OWNER TO supabase_admin;

--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


ALTER EVENT TRIGGER pgrst_ddl_watch OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


ALTER EVENT TRIGGER pgrst_drop_watch OWNER TO supabase_admin;

--
-- PostgreSQL database dump complete
--

