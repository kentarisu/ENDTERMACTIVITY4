<?php

namespace Middleware;

use PDO;
use Services\TokenService;

class AuthMiddleware
{
    public function __construct(
        private PDO $db,
        private TokenService $tokens
    ) {
    }

    public function requireUser(): ?array
    {
        $token = $this->extractBearerToken();
        $userId = $this->tokens->resolveUserId($token);

        if (!$userId) {
            json_response(['message' => 'Unauthorized'], 401);
            return null;
        }

        $stmt = $this->db->prepare('SELECT id, email, display_name, created_at FROM users WHERE id = :id');
        $stmt->execute([':id' => $userId]);
        $user = $stmt->fetch();

        if (!$user) {
            json_response(['message' => 'Unauthorized'], 401);
            return null;
        }

        return $user;
    }

    private function extractBearerToken(): ?string
    {
        $headers = getallheaders();
        $authorization = $headers['Authorization'] ?? $headers['authorization'] ?? null;

        if (!$authorization || !preg_match('/^Bearer\s+(.*)$/i', $authorization, $matches)) {
            return null;
        }

        return trim($matches[1]);
    }
}

