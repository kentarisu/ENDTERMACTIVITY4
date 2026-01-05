<?php

namespace Controllers;

use PDO;
use Services\TokenService;

class AuthController
{
    public function __construct(
        private PDO $db,
        private TokenService $tokens
    ) {
    }

    public function register(): void
    {
        $data = parse_json_body();
        $email = filter_var($data['email'] ?? null, FILTER_VALIDATE_EMAIL);
        $password = $data['password'] ?? '';
        $displayName = trim($data['displayName'] ?? '');

        // Better error messages
        $errors = [];
        if (!$email) {
            $errors[] = 'Valid email is required';
        }
        if (strlen($password) < 8) {
            $errors[] = 'Password must be at least 8 characters';
        }
        if ($displayName === '') {
            $errors[] = 'Display name is required';
        }

        if (!empty($errors)) {
            json_response(['message' => 'Invalid payload', 'errors' => $errors, 'received' => $data], 422);
            return;
        }

        $stmt = $this->db->prepare('SELECT id FROM users WHERE email = :email');
        $stmt->execute([':email' => $email]);
        if ($stmt->fetch()) {
            json_response(['message' => 'Email already registered'], 409);
            return;
        }

        $hash = password_hash($password, PASSWORD_BCRYPT);
        $insert = $this->db->prepare('INSERT INTO users (email, password_hash, display_name) VALUES (:email, :password_hash, :display_name)');
        $insert->execute([
            ':email' => $email,
            ':password_hash' => $hash,
            ':display_name' => $displayName,
        ]);

        $userId = (int) $this->db->lastInsertId();
        $token = $this->tokens->issueToken($userId);
        $user = $this->fetchUser($userId);

        json_response([
            'token' => $token,
            'user' => $user,
        ], 201);
    }

    public function login(): void
    {
        $data = parse_json_body();
        $email = filter_var($data['email'] ?? null, FILTER_VALIDATE_EMAIL);
        $password = $data['password'] ?? '';

        if (!$email || $password === '') {
            json_response(['message' => 'Invalid credentials', 'details' => 'Email and password are required'], 422);
            return;
        }

        $stmt = $this->db->prepare('SELECT id, password_hash FROM users WHERE email = :email');
        $stmt->execute([':email' => $email]);
        $record = $stmt->fetch();

        if (!$record) {
            json_response(['message' => 'Invalid credentials', 'details' => 'No account found with this email'], 401);
            return;
        }

        if (!password_verify($password, $record['password_hash'])) {
            json_response(['message' => 'Invalid credentials', 'details' => 'Incorrect password'], 401);
            return;
        }

        $token = $this->tokens->issueToken((int) $record['id']);
        $user = $this->fetchUser((int) $record['id']);

        json_response([
            'token' => $token,
            'user' => $user,
        ]);
    }

    public function profile(array $user): void
    {
        json_response(['user' => $user]);
    }

    private function fetchUser(int $id): array
    {
        $stmt = $this->db->prepare('SELECT id, email, display_name, created_at FROM users WHERE id = :id');
        $stmt->execute([':id' => $id]);
        $user = $stmt->fetch();
        if ($user) {
            // Ensure id is an integer
            $user['id'] = (int) $user['id'];
        }
        return $user ?: [];
    }
}

