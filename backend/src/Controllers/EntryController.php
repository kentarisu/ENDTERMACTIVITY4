<?php

namespace Controllers;

use Exception;
use PDO;

class EntryController
{
    public function __construct(
        private PDO $db
    ) {
    }

    public function list(): void
    {
        try {
            $status = $_GET['status'] ?? null;
            $userId = isset($_GET['user_id']) ? (int) $_GET['user_id'] : null;

            $query = 'SELECT 
                e.id, e.user_id, e.title, e.release_year, e.review, e.rating, e.status, e.poster_url, e.created_at, e.updated_at,
                u.display_name as user_name,
                (SELECT COUNT(*) FROM likes WHERE entry_id = e.id) as like_count
                FROM entries e
                JOIN users u ON e.user_id = u.id
                WHERE 1=1';

            $params = [];

            if ($status) {
                $query .= ' AND e.status = :status';
                $params[':status'] = $status;
            }

            if ($userId) {
                $query .= ' AND e.user_id = :user_id';
                $params[':user_id'] = $userId;
            }

            $query .= ' ORDER BY e.created_at DESC';

            $stmt = $this->db->prepare($query);
            if (!$stmt) {
                json_response(['message' => 'Database error', 'error' => 'Failed to prepare query'], 500);
                return;
            }

            $stmt->execute($params);
            $entries = $stmt->fetchAll(PDO::FETCH_ASSOC);

            // Ensure numeric fields are properly typed
            foreach ($entries as &$entry) {
                $entry['id'] = (int) $entry['id'];
                $entry['user_id'] = (int) $entry['user_id'];
                if ($entry['release_year'] !== null) {
                    $entry['release_year'] = (int) $entry['release_year'];
                }
                if ($entry['rating'] !== null) {
                    $entry['rating'] = (int) $entry['rating'];
                }
                if ($entry['like_count'] !== null) {
                    $entry['like_count'] = (int) $entry['like_count'];
                }
            }
            unset($entry); // Break reference

            json_response(['entries' => $entries]);
        } catch (Exception $e) {
            json_response(['message' => 'Error loading entries', 'error' => $e->getMessage()], 500);
        }
    }

    public function show(int $id): void
    {
        try {
            $stmt = $this->db->prepare('SELECT 
                e.id, e.user_id, e.title, e.release_year, e.review, e.rating, e.status, e.poster_url, e.created_at, e.updated_at,
                u.display_name as user_name,
                (SELECT COUNT(*) FROM likes WHERE entry_id = e.id) as like_count
                FROM entries e
                JOIN users u ON e.user_id = u.id
                WHERE e.id = :id');
            
            if (!$stmt) {
                json_response(['message' => 'Database error', 'error' => 'Failed to prepare query'], 500);
                return;
            }
            
            $stmt->execute([':id' => $id]);
            $entry = $stmt->fetch(PDO::FETCH_ASSOC);

            if (!$entry) {
                json_response(['message' => 'Entry not found'], 404);
                return;
            }

            // Ensure numeric fields are properly typed
            $entry['id'] = (int) $entry['id'];
            $entry['user_id'] = (int) $entry['user_id'];
            if ($entry['release_year'] !== null) {
                $entry['release_year'] = (int) $entry['release_year'];
            }
            if ($entry['rating'] !== null) {
                $entry['rating'] = (int) $entry['rating'];
            }
            if ($entry['like_count'] !== null) {
                $entry['like_count'] = (int) $entry['like_count'];
            }

            json_response(['entry' => $entry]);
        } catch (Exception $e) {
            json_response(['message' => 'Error loading entry', 'error' => $e->getMessage()], 500);
        }
    }

    public function create(int $userId): void
    {
        $data = parse_json_body();
        $title = trim($data['title'] ?? '');
        $releaseYear = isset($data['release_year']) ? (int) $data['release_year'] : null;
        $review = trim($data['review'] ?? '');
        $rating = isset($data['rating']) ? (int) $data['rating'] : null;
        $status = $data['status'] ?? 'planning';
        $posterUrl = trim($data['poster_url'] ?? '');

        // Validation
        if ($title === '') {
            json_response(['message' => 'Title is required'], 422);
            return;
        }

        if (!in_array($status, ['planning', 'watching', 'watched'])) {
            json_response(['message' => 'Invalid status'], 422);
            return;
        }

        if ($rating !== null && ($rating < 1 || $rating > 10)) {
            json_response(['message' => 'Rating must be between 1 and 10'], 422);
            return;
        }

        $stmt = $this->db->prepare('INSERT INTO entries (user_id, title, release_year, review, rating, status, poster_url) 
            VALUES (:user_id, :title, :release_year, :review, :rating, :status, :poster_url)');
        $stmt->execute([
            ':user_id' => $userId,
            ':title' => $title,
            ':release_year' => $releaseYear,
            ':review' => $review ?: null,
            ':rating' => $rating,
            ':status' => $status,
            ':poster_url' => $posterUrl ?: null,
        ]);

        $entryId = (int) $this->db->lastInsertId();
        $this->show($entryId);
    }

    public function update(int $id, int $userId): void
    {
        // Check ownership
        $stmt = $this->db->prepare('SELECT user_id FROM entries WHERE id = :id');
        $stmt->execute([':id' => $id]);
        $entry = $stmt->fetch();

        if (!$entry) {
            json_response(['message' => 'Entry not found'], 404);
            return;
        }

        if ((int) $entry['user_id'] !== $userId) {
            json_response(['message' => 'Forbidden'], 403);
            return;
        }

        $data = parse_json_body();
        $title = isset($data['title']) ? trim($data['title']) : null;
        $releaseYear = isset($data['release_year']) ? (int) $data['release_year'] : null;
        $review = isset($data['review']) ? trim($data['review']) : null;
        $rating = isset($data['rating']) ? ((int) $data['rating'] ?: null) : null;
        $status = $data['status'] ?? null;
        $posterUrl = isset($data['poster_url']) ? trim($data['poster_url']) : null;

        // Validation
        if ($title !== null && $title === '') {
            json_response(['message' => 'Title cannot be empty'], 422);
            return;
        }

        if ($status !== null && !in_array($status, ['planning', 'watching', 'watched'])) {
            json_response(['message' => 'Invalid status'], 422);
            return;
        }

        if ($rating !== null && ($rating < 1 || $rating > 10)) {
            json_response(['message' => 'Rating must be between 1 and 10'], 422);
            return;
        }

        // Build update query dynamically
        $updates = [];
        $params = [':id' => $id];

        if ($title !== null) {
            $updates[] = 'title = :title';
            $params[':title'] = $title;
        }
        if ($releaseYear !== null) {
            $updates[] = 'release_year = :release_year';
            $params[':release_year'] = $releaseYear;
        }
        if ($review !== null) {
            $updates[] = 'review = :review';
            $params[':review'] = $review ?: null;
        }
        if ($rating !== null) {
            $updates[] = 'rating = :rating';
            $params[':rating'] = $rating;
        }
        if ($status !== null) {
            $updates[] = 'status = :status';
            $params[':status'] = $status;
        }
        if ($posterUrl !== null) {
            $updates[] = 'poster_url = :poster_url';
            $params[':poster_url'] = $posterUrl ?: null;
        }

        if (empty($updates)) {
            $this->show($id);
            return;
        }

        $query = 'UPDATE entries SET ' . implode(', ', $updates) . ' WHERE id = :id';
        $stmt = $this->db->prepare($query);
        $stmt->execute($params);

        $this->show($id);
    }

    public function delete(int $id, int $userId): void
    {
        // Check ownership
        $stmt = $this->db->prepare('SELECT user_id FROM entries WHERE id = :id');
        $stmt->execute([':id' => $id]);
        $entry = $stmt->fetch();

        if (!$entry) {
            json_response(['message' => 'Entry not found'], 404);
            return;
        }

        if ((int) $entry['user_id'] !== $userId) {
            json_response(['message' => 'Forbidden'], 403);
            return;
        }

        $stmt = $this->db->prepare('DELETE FROM entries WHERE id = :id');
        $stmt->execute([':id' => $id]);

        json_response(['message' => 'Entry deleted successfully']);
    }

    public function like(int $entryId, int $userId): void
    {
        // Check if entry exists
        $stmt = $this->db->prepare('SELECT id FROM entries WHERE id = :id');
        $stmt->execute([':id' => $entryId]);
        if (!$stmt->fetch()) {
            json_response(['message' => 'Entry not found'], 404);
            return;
        }

        // Check if already liked
        $stmt = $this->db->prepare('SELECT id FROM likes WHERE entry_id = :entry_id AND user_id = :user_id');
        $stmt->execute([':entry_id' => $entryId, ':user_id' => $userId]);
        if ($stmt->fetch()) {
            json_response(['message' => 'Already liked'], 409);
            return;
        }

        $stmt = $this->db->prepare('INSERT INTO likes (entry_id, user_id) VALUES (:entry_id, :user_id)');
        $stmt->execute([':entry_id' => $entryId, ':user_id' => $userId]);

        json_response(['message' => 'Entry liked']);
    }

    public function unlike(int $entryId, int $userId): void
    {
        $stmt = $this->db->prepare('DELETE FROM likes WHERE entry_id = :entry_id AND user_id = :user_id');
        $stmt->execute([':entry_id' => $entryId, ':user_id' => $userId]);

        if ($stmt->rowCount() === 0) {
            json_response(['message' => 'Like not found'], 404);
            return;
        }

        json_response(['message' => 'Entry unliked']);
    }
}
