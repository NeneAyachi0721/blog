# 部署

## 1. 环境要求

| 依赖     | 版本     |
| :------- | :------- |
| JDK      | 17+      |
| Maven    | 3.8+     |
| MySQL    | 8.0+     |
| Node.js  | 18+      |

## 2. 数据库初始化

```bash
cd sql
mysql -u root -p
```

```sql
CREATE DATABASE blog;
USE blog;
source blog.sql;
```

## 3. 修改后端配置

文件位置: `backend/src/main/resources/application.properties`

修改数据库密码:

```properties
spring.datasource.password=your_datasource_password
```

## 4. 启动后端

```bash
cd backend
mvn spring-boot:run
```

访问接口文档: <http://localhost:1235/doc.html>

管理员账号: `admin` / `admin`(API 文档调试)

## 5. 启动前端

```bash
cd frontend
npm install
npm run serve
```

访问前端: <http://localhost:8080>

管理员账号: `admin` / `123456`(系统后台登录)
