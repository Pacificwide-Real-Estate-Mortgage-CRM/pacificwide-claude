---
name: ck:databases
description: Design schemas, write queries for MongoDB and PostgreSQL. Use for database design, SQL/NoSQL queries, aggregation pipelines, indexes, migrations, replication, performance optimization, psql CLI.
license: MIT
argument-hint: "[query or schema task]"
---

# Databases Skill

## When to Use

- Designing database schemas and data models
- Writing SQL or MongoDB queries
- Building aggregation pipelines or complex joins
- Optimizing indexes and query performance
- Implementing migrations, replication, backups
- Analyzing slow queries and performance issues

## Reference Navigation

- `db-design.md` — Schema design for OLTP/OLAP, normalization, fact/dimension tables
- `mongodb-crud.md` — CRUD operations, query operators, atomic updates
- `mongodb-aggregation.md` — Aggregation pipeline, stages, operators
- `mongodb-indexing.md` — Index types, compound indexes, performance
- `postgresql-queries.md` — SELECT, JOINs, CTEs, window functions
- `postgresql-psql-cli.md` — psql commands, meta-commands, scripting
- `postgresql-performance.md` — EXPLAIN ANALYZE, vacuum, index tuning
- `postgresql-administration.md` — User management, backups, replication

## Best Practices

**PostgreSQL:** Normalize to 3NF, index FKs + filtered columns, EXPLAIN ANALYZE for optimization, pgBouncer for connection pooling, regular VACUUM/ANALYZE

**MongoDB:** Embed for 1-to-few, reference for 1-to-many, index queried fields, aggregation pipeline for transforms, enable auth + TLS in production

## Resources

- MongoDB: https://www.mongodb.com/docs/
- PostgreSQL: https://www.postgresql.org/docs/
