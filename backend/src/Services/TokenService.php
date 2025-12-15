<?php

namespace Services;

use DateInterval;
use DateTimeImmutable;
use PDO;

class TokenService
{
    public function __construct(
        private PDO $db,
        private int $ttlMinutes
    ) {
    }

    public function issueToken(int $userId): string
    {
        $token = bin2hex(random_bytes(32));
        $expiresAt = (new DateTimeImmutable())->add(new DateInterval('PT' . $this->ttlMinutes . 'M'));

        $stmt = $this->db->prepare('INSERT INTO auth_tokens (user_id, token, expires_at) VALUES (:user_id, :token, :expires_at)');
        $stmt->execute([
            ':user_id' => $userId,
            ':token' => $token,
            ':expires_at' => $expiresAt->format('Y-m-d H:i:s'),
        ]);

        return $token;
    }

    public function resolveUserId(?string $token): ?int
    {
        if (!$token) {
            return null;
        }

        $stmt = $this->db->prepare('SELECT user_id FROM auth_tokens WHERE token = :token AND expires_at > NOW()');
        $stmt->execute([':token' => $token]);
        $result = $stmt->fetch();

        return $result ? (int) $result['user_id'] : null;
    }

    public function revokeToken(string $token): void
    {
        $stmt = $this->db->prepare('DELETE FROM auth_tokens WHERE token = :token');
        $stmt->execute([':token' => $token]);
    }
}

