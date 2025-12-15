Activity 4 – Flutter + MySQL Integration Plan
============================================

Overview
--------
- Working title: **FlickLog**, a mini social diary for movies (avoid the “Letterboxd” name but mimic core CRUD features).
- Platforms: Flutter (Android + iOS) backed by a lightweight PHP REST API that talks to MySQL.
- Core user actions: register, log in, create movie diary entries (title, year, review, rating, status), browse everyone’s entries, edit their own, and delete.

High-Level Architecture
-----------------------
1. Flutter app
   - State management: Riverpod or Provider (either is acceptable; Riverpod sample below).
   - Networking: `dio` (preferred for interceptors + error handling).
   - Secure storage: `flutter_secure_storage` for JWT/Session token.
   - Routing: `go_router` for guarded routes.
2. PHP REST API
   - Slim/Lumen/Laravel Zero or pure PHP with a router.
   - PDO for parameterized MySQL queries.
   - JWT authentication (Firebase PHP-JWT) or session tokens.
3. MySQL 8.x
   - Hosted locally (XAMPP/WAMP) or remote.
   - Follows normalized schema described below.

Suggested Folder Layout
-----------------------
```
ENDTERMACTIVITY4/
├── backend/
│   ├── public/index.php         # Slim entrypoint / router
│   ├── src/
│   │   ├── Database.php         # PDO singleton
│   │   ├── Controllers/
│   │   │   ├── AuthController.php
│   │   │   └── EntryController.php
│   │   └── Middleware/Auth.php
│   └── composer.json
├── database/
│   ├── schema.sql               # CREATE TABLE statements
│   └── seed.sql                 # Demo users + entries
├── flutter_app/
│   └── lib/
│       ├── main.dart
│       ├── app_router.dart
│       ├── models/
│       ├── services/api_client.dart
│       ├── providers/
│       ├── screens/
│       └── widgets/
└── docs/
    └── activity4_plan.md
```

Database Schema (MySQL)
-----------------------
```sql
CREATE TABLE users (
    id            BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    email         VARCHAR(120) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    display_name  VARCHAR(80)  NOT NULL,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE entries (
    id            BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id       BIGINT UNSIGNED NOT NULL,
    title         VARCHAR(150) NOT NULL,
    release_year  SMALLINT,
    review        TEXT,
    rating        TINYINT CHECK (rating BETWEEN 1 AND 10),
    status        ENUM('planning','watching','watched') DEFAULT 'planning',
    poster_url    VARCHAR(255),
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE likes (
    id        BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    entry_id  BIGINT UNSIGNED NOT NULL,
    user_id   BIGINT UNSIGNED NOT NULL,
    UNIQUE KEY unique_like (entry_id, user_id),
    FOREIGN KEY (entry_id) REFERENCES entries(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id)  REFERENCES users(id)  ON DELETE CASCADE
);
```

Essential REST Endpoints
------------------------
| Method | Path                  | Auth? | Purpose                           |
|--------|-----------------------|-------|-----------------------------------|
| POST   | `/api/auth/register`  | No    | Create user (returns token).      |
| POST   | `/api/auth/login`     | No    | Exchange credentials for token.   |
| GET    | `/api/profile`        | Yes   | Returns current user profile.     |
| GET    | `/api/entries`        | No    | Browse all entries (with filters).|
| GET    | `/api/entries/{id}`   | No    | Entry detail.                     |
| POST   | `/api/entries`        | Yes   | Create entry for current user.    |
| PUT    | `/api/entries/{id}`   | Yes   | Update owned entry.               |
| DELETE | `/api/entries/{id}`   | Yes   | Delete owned entry.               |
| POST   | `/api/entries/{id}/like`   | Yes | Like entry.                   |
| DELETE | `/api/entries/{id}/like`  | Yes | Unlike entry.                  |

Sample PHP Controller Logic (Slim style)
----------------------------------------
```php
// src/Controllers/AuthController.php
public function register(ServerRequestInterface $request, ResponseInterface $response): ResponseInterface {
    $data = $request->getParsedBody();
    $email = filter_var($data['email'] ?? '', FILTER_VALIDATE_EMAIL);
    $password = $data['password'] ?? '';
    if (!$email || strlen($password) < 8) {
        return $this->json($response, ['message' => 'Invalid payload'], 422);
    }
    $hash = password_hash($password, PASSWORD_BCRYPT);
    $stmt = $this->db->prepare('INSERT INTO users (email, password_hash, display_name) VALUES (:email, :hash, :name)');
    $stmt->execute([':email' => $email, ':hash' => $hash, ':name' => $data['displayName'] ?? 'Movie Lover']);
    $token = $this->jwt->encode(['sub' => $this->db->lastInsertId()]);
    return $this->json($response, ['token' => $token], 201);
}
```

Flutter Networking Layer (Riverpod + Dio)
-----------------------------------------
```dart
// lib/services/api_client.dart
class ApiClient {
  ApiClient(this._dio, this._storage);
  final Dio _dio;
  final FlutterSecureStorage _storage;

  Future<Response<T>> _authorizedRequest<T>(
    Future<Response<T>> Function(String token) request,
  ) async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null) throw const UnauthorizedException();
    return request(token);
  }

  Future<User> register(String email, String password, String displayName) async {
    final response = await _dio.post('/auth/register', data: {
      'email': email,
      'password': password,
      'displayName': displayName,
    });
    await _storage.write(key: 'auth_token', value: response.data['token']);
    return User.fromJson(response.data['user']);
  }

  Future<List<Entry>> fetchEntries({String? status}) async {
    final response = await _dio.get('/entries', queryParameters: {'status': status});
    return (response.data as List).map((json) => Entry.fromJson(json)).toList();
  }
}
```

Screen Flow
-----------
1. **Splash** – checks secure storage for token → route to login or home.
2. **Login / Register** – forms with validation, hitting auth endpoints.
3. **Home / Feed** – `FutureProvider` fetching `/entries`, list view with cards.
4. **Entry Detail** – shows review, rating, likes; allows like/unlike for logged-in users.
5. **Entry Form** – create/update forms for owned entries (validate rating 1–10).
6. **Profile** – display user info, logout button (clears token + providers).

CRUD Demonstration
------------------
- Create: Submit entry form → POST `/api/entries`.
- Read: Home feed + detail screen (list + detail views).
- Update: Entry form opened in edit mode (prefill existing values) → PUT endpoint.
- Delete: Confirmation dialog → DELETE endpoint.

Testing & Validation
--------------------
- Backend: PHPUnit tests for controllers + Postman collection for manual checks.
- Flutter: Widget tests for form validation + integration test for login → feed.
- Security: Hash passwords, validate payloads, enforce ownership checks on updates/deletes, rate-limit auth routes if exposed publicly.

Implementation Order
--------------------
1. Create MySQL schema (`database/schema.sql`) and dummy data (`seed.sql`).
2. Bootstrap PHP backend (composer dependencies: slim/slim, vlucas/phpdotenv, firebase/php-jwt).
3. Implement auth + entries controllers with token middleware.
4. Scaffold Flutter project, add dependencies (`dio`, `flutter_secure_storage`, `hooks_riverpod`, `go_router`, `intl`).
5. Build models + API service + providers, then UI screens.
6. Connect Flutter forms to API, add optimistic UI updates.
7. Final QA: run backend PHPUnit, Flutter `flutter analyze` + `flutter test`, manual device test.

Next Steps
----------
- Flesh out backend route handlers in `backend/controllers`.
- Generate Flutter project (`flutter create flutter_app`) and hydrate `lib/` per structure above.
- Write `docs/api_contract.md` with exact request/response examples once endpoints are finalized.

