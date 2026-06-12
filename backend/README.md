# backend

## Project setup

```bash
mvn clean install
```

### Compiles and hot-reloads for development

```bash
mvn spring-boot:run
```

### Compiles and minifies for production

```bash
mvn clean package
```

### Runs tests

```bash
mvn test
```

### Customize configuration

See [Spring Boot Reference Documentation](https://docs.spring.io/spring-boot/docs/current/reference/html/).

---

## Requirements

| Dependency | Version |
| :--------- | :------ |
| JDK        | 17+     |
| Maven      | 3.9+    |
| MySQL      | 8.0+    |

## Configuration

Edit database configuration in `src/main/resources/application.properties`:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/blog?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai
spring.datasource.username=root
spring.datasource.password=your_datasource_password
```

## API Documentation

After starting the application, visit:

[http://localhost:1235/doc.html](http://localhost:1235/doc.html)

Admin account for API doc debugging: `admin` / `admin`
