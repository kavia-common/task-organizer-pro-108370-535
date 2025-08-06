-- PostgreSQL schema for users and tasks
-- Run this as the appuser on myapp database

-- USERS TABLE
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    full_name VARCHAR(255),
    password_hash VARCHAR(255) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- TASKS TABLE
CREATE TABLE IF NOT EXISTS tasks (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    status VARCHAR(50) NOT NULL DEFAULT 'todo',
    due_date DATE,
    creator_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    assignee_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Indexes for filtering/searching
CREATE INDEX IF NOT EXISTS idx_tasks_status ON tasks(status);
CREATE INDEX IF NOT EXISTS idx_tasks_assignee_id ON tasks(assignee_id);
CREATE INDEX IF NOT EXISTS idx_tasks_due_date ON tasks(due_date);

-- Trigger to update updated_at on row change for users table
CREATE OR REPLACE FUNCTION update_users_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
   NEW.updated_at = NOW();
   RETURN NEW;
END;
$$ language 'plpgsql';

DROP TRIGGER IF EXISTS set_users_updated_at ON users;
CREATE TRIGGER set_users_updated_at
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE PROCEDURE update_users_updated_at_column();

-- Trigger to update updated_at on row change for tasks table
CREATE OR REPLACE FUNCTION update_tasks_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
   NEW.updated_at = NOW();
   RETURN NEW;
END;
$$ language 'plpgsql';

DROP TRIGGER IF EXISTS set_tasks_updated_at ON tasks;
CREATE TRIGGER set_tasks_updated_at
BEFORE UPDATE ON tasks
FOR EACH ROW
EXECUTE PROCEDURE update_tasks_updated_at_column();

-- End of schema
