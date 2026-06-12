# sql

## Database setup

```bash
mysql -u root -p
```

### Create database

```sql
CREATE DATABASE blog;
USE blog;
source blog.sql;
```

### Reset database

```sql
DROP DATABASE blog;
CREATE DATABASE blog;
USE blog;
source blog.sql;
```

---

## Requirements

| Dependency | Version |
| :--------- | :------ |
| MySQL      | 8.0+    |

## Notes

- Ensure MySQL service is running before executing the scripts.
- The `blog.sql` file contains all table structures and initial data.
- Use `DROP DATABASE blog;` with caution, as it will permanently delete all data in the database.
