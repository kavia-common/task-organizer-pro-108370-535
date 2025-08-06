# Database Schema Setup for Task Management

## Initialization

To initialize the PostgreSQL schema for the `users` and `tasks` tables, run the following command inside the `task_management_database` directory:

```bash
# Use the psql command string from db_connection.txt:
psql postgresql://appuser:dbuser123@localhost:5000/myapp -f init_schema.sql
```

This will create or update the required tables to match the backend models.

## Requirements

- The `init_schema.sql` script should be run as a user with sufficient privilege to create tables and triggers (by default, `appuser`).
- The database connection string is provided in `db_connection.txt`.
- Tables and fields are designed to align with backend API expectations.

## Notes

- Foreign keys: `creator_id` and `assignee_id` reference the users table (with `ON DELETE CASCADE/SET NULL` actions).
- Timestamps (`created_at`, `updated_at`) are automatically set/updated.
- Ensure this script is run after the initial database/user setup via `startup.sh`.
