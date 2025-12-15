# Database Schema Documentation
## FlickLog - Movie Diary Application

**Database Name:** `flicklog`  
**Character Set:** `utf8mb4`  
**Collation:** `utf8mb4_unicode_ci`

---

## Overview

The FlickLog database schema is designed to support a social movie diary application where users can:
- Register and authenticate
- Create, read, update, and delete movie entries
- Rate and review movies
- Track viewing status (planning, watching, watched)
- Like entries from other users

---

## Entity Relationship Diagram

```
┌─────────────┐
│    users    │
├─────────────┤
│ id (PK)     │
│ email       │
│ password    │
│ display_name│
│ created_at  │
└──────┬──────┘
       │
       │ 1:N
       │
       ├─────────────────┐
       │                 │
       ▼                 ▼
┌─────────────┐   ┌─────────────┐
│   entries   │   │ auth_tokens │
├─────────────┤   ├─────────────┤
│ id (PK)     │   │ id (PK)     │
│ user_id (FK)│   │ user_id (FK)│
│ title       │   │ token       │
│ release_year│   │ expires_at  │
│ review      │   │ created_at  │
│ rating      │   └─────────────┘
│ status      │
│ poster_url  │
│ created_at  │
│ updated_at  │
└──────┬──────┘
       │
       │ 1:N
       │
       ▼
┌─────────────┐
│    likes    │
├─────────────┤
│ id (PK)     │
│ entry_id(FK)│
│ user_id(FK) │
│ created_at  │
└─────────────┘
```

---

## Tables

### 1. `users`

Stores user account information.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | `BIGINT UNSIGNED` | PRIMARY KEY, AUTO_INCREMENT | Unique user identifier |
| `email` | `VARCHAR(120)` | NOT NULL, UNIQUE | User's email address (used for login) |
| `password_hash` | `VARCHAR(255)` | NOT NULL | Bcrypt hashed password |
| `display_name` | `VARCHAR(80)` | NOT NULL | User's display name shown in the app |
| `created_at` | `TIMESTAMP` | DEFAULT CURRENT_TIMESTAMP | Account creation timestamp |

**Indexes:**
- Primary Key: `id`
- Unique Index: `email`

**Relationships:**
- One-to-Many with `entries` (a user can have many entries)
- One-to-Many with `auth_tokens` (a user can have multiple active tokens)
- One-to-Many with `likes` (a user can like many entries)

**Example Data:**
```sql
INSERT INTO users (email, password_hash, display_name) 
VALUES ('user@example.com', '$2y$10$...', 'Movie Lover');
```

---

### 2. `auth_tokens`

Stores authentication tokens for session management.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | `BIGINT UNSIGNED` | PRIMARY KEY, AUTO_INCREMENT | Unique token record identifier |
| `user_id` | `BIGINT UNSIGNED` | NOT NULL, FOREIGN KEY | Reference to users.id |
| `token` | `CHAR(64)` | NOT NULL, UNIQUE | 64-character hexadecimal token |
| `expires_at` | `DATETIME` | NOT NULL | Token expiration date and time |
| `created_at` | `TIMESTAMP` | DEFAULT CURRENT_TIMESTAMP | Token creation timestamp |

**Indexes:**
- Primary Key: `id`
- Unique Index: `token`
- Foreign Key: `user_id` → `users.id` (ON DELETE CASCADE)

**Relationships:**
- Many-to-One with `users` (each token belongs to one user)

**Cascade Behavior:**
- When a user is deleted, all their tokens are automatically deleted (CASCADE)

**Token Lifecycle:**
- Tokens are generated as 64-character hexadecimal strings (32 bytes)
- Default TTL: 24 hours (configurable in `backend/config.php`)
- Expired tokens are automatically ignored during authentication

---

### 3. `entries`

Stores movie diary entries created by users.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | `BIGINT UNSIGNED` | PRIMARY KEY, AUTO_INCREMENT | Unique entry identifier |
| `user_id` | `BIGINT UNSIGNED` | NOT NULL, FOREIGN KEY | Reference to users.id (entry owner) |
| `title` | `VARCHAR(150)` | NOT NULL | Movie title |
| `release_year` | `SMALLINT` | NULL | Year the movie was released |
| `review` | `TEXT` | NULL | User's written review |
| `rating` | `TINYINT` | NULL, CHECK (1-10) | User's rating (1-10 scale) |
| `status` | `ENUM` | DEFAULT 'planning' | Viewing status: 'planning', 'watching', 'watched' |
| `poster_url` | `VARCHAR(255)` | NULL | URL to movie poster image |
| `created_at` | `TIMESTAMP` | DEFAULT CURRENT_TIMESTAMP | Entry creation timestamp |
| `updated_at` | `TIMESTAMP` | DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP | Last update timestamp |

**Indexes:**
- Primary Key: `id`
- Foreign Key: `user_id` → `users.id` (ON DELETE CASCADE)
- Check Constraint: `rating` must be between 1 and 10 (or NULL)

**ENUM Values:**
- `'planning'` - User plans to watch this movie
- `'watching'` - User is currently watching this movie
- `'watched'` - User has finished watching this movie

**Relationships:**
- Many-to-One with `users` (each entry belongs to one user)
- One-to-Many with `likes` (an entry can have many likes)

**Cascade Behavior:**
- When a user is deleted, all their entries are automatically deleted (CASCADE)
- When an entry is deleted, all its likes are automatically deleted (CASCADE)

**Example Data:**
```sql
INSERT INTO entries (user_id, title, release_year, review, rating, status) 
VALUES (1, 'The Grand Budapest Hotel', 2014, 'A whimsical ride with sharp humor.', 9, 'watched');
```

---

### 4. `likes`

Stores user likes on movie entries (many-to-many relationship between users and entries).

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | `BIGINT UNSIGNED` | PRIMARY KEY, AUTO_INCREMENT | Unique like identifier |
| `entry_id` | `BIGINT UNSIGNED` | NOT NULL, FOREIGN KEY | Reference to entries.id |
| `user_id` | `BIGINT UNSIGNED` | NOT NULL, FOREIGN KEY | Reference to users.id (who liked) |
| `created_at` | `TIMESTAMP` | DEFAULT CURRENT_TIMESTAMP | Like creation timestamp |

**Indexes:**
- Primary Key: `id`
- Unique Composite Index: `(entry_id, user_id)` - prevents duplicate likes
- Foreign Key: `entry_id` → `entries.id` (ON DELETE CASCADE)
- Foreign Key: `user_id` → `users.id` (ON DELETE CASCADE)

**Relationships:**
- Many-to-One with `entries` (each like belongs to one entry)
- Many-to-One with `users` (each like belongs to one user)

**Business Rules:**
- A user can only like an entry once (enforced by unique constraint)
- Users cannot like their own entries (enforced in application logic)

**Cascade Behavior:**
- When an entry is deleted, all its likes are automatically deleted (CASCADE)
- When a user is deleted, all their likes are automatically deleted (CASCADE)

**Example Data:**
```sql
INSERT INTO likes (entry_id, user_id) 
VALUES (1, 2);  -- User 2 likes Entry 1
```

---

## Data Types and Constraints

### Numeric Types
- **BIGINT UNSIGNED**: Used for IDs to support large datasets (0 to 18,446,744,073,709,551,615)
- **SMALLINT**: Used for release years (sufficient for years -32,768 to 32,767)
- **TINYINT**: Used for ratings (1-10 scale, -128 to 127)

### String Types
- **VARCHAR(n)**: Variable-length strings with maximum length
  - `VARCHAR(120)` for emails (sufficient for most email addresses)
  - `VARCHAR(150)` for movie titles
  - `VARCHAR(255)` for URLs
  - `VARCHAR(80)` for display names
- **TEXT**: Variable-length text for reviews (up to 65,535 characters)
- **CHAR(64)**: Fixed-length strings for tokens (64 hexadecimal characters)

### Temporal Types
- **TIMESTAMP**: Automatic timestamp management
  - `created_at`: Set on INSERT
  - `updated_at`: Automatically updated on UPDATE
- **DATETIME**: Explicit date/time for token expiration

### ENUM Type
- **ENUM('planning','watching','watched')**: Restricted set of values for entry status

---

## Foreign Key Relationships

### Cascade Deletion Rules

1. **users → entries**: CASCADE
   - Deleting a user deletes all their entries

2. **users → auth_tokens**: CASCADE
   - Deleting a user deletes all their tokens

3. **users → likes**: CASCADE
   - Deleting a user deletes all their likes

4. **entries → likes**: CASCADE
   - Deleting an entry deletes all likes on that entry

---

## Indexes and Performance

### Primary Indexes
- All tables have `id` as PRIMARY KEY (clustered index)

### Unique Indexes
- `users.email`: Ensures email uniqueness
- `auth_tokens.token`: Ensures token uniqueness
- `likes(entry_id, user_id)`: Prevents duplicate likes

### Foreign Key Indexes
- Foreign key columns are automatically indexed for join performance

### Query Optimization
- Common queries filter by `user_id` and `entry_id` (indexed)
- Entries are typically sorted by `created_at DESC` (timestamp index recommended for large datasets)

---

## Data Integrity

### Constraints
1. **Email Uniqueness**: Enforced at database level
2. **Token Uniqueness**: Enforced at database level
3. **Rating Range**: CHECK constraint ensures 1-10 or NULL
4. **Status Values**: ENUM restricts to valid statuses
5. **Like Uniqueness**: Composite unique constraint prevents duplicate likes

### Validation
- Application layer validates:
  - Email format
  - Password strength (minimum 8 characters)
  - Display name non-empty
  - Title non-empty
  - Release year range (1888 to current year + 10)
  - Rating range (1-10)

---

## Security Considerations

### Password Storage
- Passwords are hashed using bcrypt (PHP's `password_hash()`)
- Never stored in plain text
- Hash length: 60 characters (bcrypt standard)

### Token Security
- Tokens are 64-character hexadecimal strings (32 random bytes)
- Tokens expire after configured TTL (default: 24 hours)
- Tokens are stored securely in Flutter app using `flutter_secure_storage`

### SQL Injection Prevention
- All queries use prepared statements with parameterized queries (PDO)
- User input is validated and sanitized before database operations

---

## Sample Queries

### Get all entries with user information
```sql
SELECT 
    e.id, e.title, e.release_year, e.rating, e.status,
    u.display_name as user_name,
    (SELECT COUNT(*) FROM likes WHERE entry_id = e.id) as like_count
FROM entries e
JOIN users u ON e.user_id = u.id
ORDER BY e.created_at DESC;
```

### Get entries by status
```sql
SELECT * FROM entries 
WHERE status = 'watched' 
ORDER BY rating DESC;
```

### Get user's entries
```sql
SELECT * FROM entries 
WHERE user_id = ? 
ORDER BY created_at DESC;
```

### Get entry with like count
```sql
SELECT 
    e.*,
    u.display_name as user_name,
    (SELECT COUNT(*) FROM likes WHERE entry_id = e.id) as like_count
FROM entries e
JOIN users u ON e.user_id = u.id
WHERE e.id = ?;
```

---

## Migration and Maintenance

### Creating the Database
```sql
CREATE DATABASE IF NOT EXISTS flicklog 
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### Running the Schema
Execute `database/schema.sql` to create all tables with proper relationships.

### Seeding Data
Execute `database/seed.sql` to insert sample data for testing.

### Backup Recommendations
- Regular backups of the `flicklog` database
- Backup frequency: Daily for production, weekly for development
- Retain backups for at least 30 days

---

## Version History

- **v1.0** (Initial Schema)
  - Created all four tables
  - Established foreign key relationships
  - Added constraints and indexes
  - Implemented cascade deletion rules

---

## Notes

1. **Character Set**: Using `utf8mb4` to support full Unicode including emojis
2. **Timestamps**: All timestamps are stored in UTC
3. **Soft Deletes**: Currently using hard deletes with CASCADE. Consider soft deletes for production if data recovery is needed
4. **Scaling**: For large datasets, consider:
   - Partitioning `entries` table by `created_at`
   - Adding indexes on frequently queried columns
   - Implementing pagination for entry lists
