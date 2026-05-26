# GEMINI.md

## Agent Rules

### Coding Style

Style definition: `extra/eclipse-ustom.xml` (Google Java Style Guide with customizations)

- **Indentation**: 4 spaces (differs from Google's 2). Continuation indent adds 2 more levels.
- **Max line length**: 100 characters.
- **Braces**: Opening brace at end of declaration line (K&R style). Spaces before/after braces.
- **Whitespace**: Spaces around operators and between keywords and parentheses.
- **Blank lines**: After `package`, after `import` groups, between methods, between class declarations.
- **Other**: `else if` on a single line; compact settings.

### Naming Conventions

| Target          | Format               | Rules                                                                                              |
| --------------- | -------------------- | -------------------------------------------------------------------------------------------------- |
| Package         | all lowercase        | `com.s_giken.training.{app}.{layer}`                                                               |
| Class/Interface | UpperCamelCase       | Suffix: `XxxController`, `XxxService`, `XxxServiceImpl`, `XxxRepository`; Entity: descriptive noun |
| Method          | lowerCamelCase       | `verb + object` format (e.g., `searchAndListing`)                                                  |
| Variable        | lowerCamelCase       | No abbreviations; meaningful names                                                                 |
| Constant        | SCREAMING_SNAKE_CASE | Applied to `public static final` fields                                                            |
| DB Table        | `T_` + UPPER_SNAKE   | e.g., `T_MEMBER`                                                                                   |
| DB Column       | snake_case           | e.g., `member_id`, `start_date`                                                                    |

### Syntactic Constraints

- **Auto-format**: Applied on save via `extra/eclipse-java-google-style-custom.xml`.
- **Java syntax**: Latest Java syntax (Record Patterns, Pattern Matching for Switch, etc.) is permitted within the bounds of readability.

### Error Handling and Termination

- **Exceptions**: Throw unexpected errors and catch at appropriate layers. Use custom exceptions for business logic errors. Avoid catching broad types (`Exception`, `Throwable`); use specific exceptions.
- **Logging**: On error, output detailed message and stack trace at the appropriate log level.
- **Resource release**: Use `try-with-resources` or equivalent for reliable cleanup.
- **Program termination**: Batch abnormal exits must return appropriate exit codes considering downstream impact.

## Project Overview

Containerized dev environment based on Ubuntu 24.04 for use with VSCode Dev Containers.

- **Java** 21+, **DB**: PostgreSQL
- Orchestrated via Docker / Docker Compose.

## Building and Running

**Prerequisites**: VSCode, Docker Desktop (or Docker for Linux), Git

**Getting started**: Clone repo → Open in VSCode → "Reopen in Container"

**Compile (Maven Wrapper)**:

```bash
./mvnw clean compile        # entire project
./mvnw -pl webapp compile   # webapp only
./mvnw -pl batch compile    # batch only
```

**Database**: PostgreSQL starts automatically.

- Hostname: `database` / User: `trainingapp` / Password: `trainingapp` / Database: `trainingapp`

## Development Conventions

- **Source**: `src/main/java` (follow naming conventions for package structure)
- **Test data**: `src/test/resources/testData` (SQL, CSV, etc.)
- **Test code**: `src/test/java` (mirror source package structure)
- **Encoding**: UTF-8 and Shift-JIS both supported.

## Sample Programs

An existing system provided for modification practice. Target folders: `webapp` and `batch`.

### `webapp` (Web Application)

Spring Boot MVC architecture.

- **Stack**: Spring Boot, Spring MVC, Spring JDBC (JdbcTemplate), Thymeleaf, Lombok
- **Layers**:
  - **Controller** (`@Controller`): HTTP request handling and screen transitions.
  - **Service** (`@Service`): Business logic. Split into interface + implementation.
  - **Repository** (`@Repository`): SQL execution via JdbcTemplate. Split into interface + implementation.
  - **Entity/Model**: Maps to DB tables. Used with `RowMapper` to map query results to objects.

### `batch` (Batch Application)

Spring Boot command-line batch.

- **Stack**: Spring Boot, Spring JDBC (JdbcTemplate)
- **Architecture**: `BatchApplication.java` implements `CommandLineRunner`. DB fetch → process → re-register logic goes in the `run` method.
