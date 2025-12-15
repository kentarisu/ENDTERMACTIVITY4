<?php

require_once __DIR__ . '/../src/bootstrap.php';

use Controllers\AuthController;
use Controllers\EntryController;
use Middleware\AuthMiddleware;
use Services\TokenService;

$config = require __DIR__ . '/../config.php';
$db = Database::connection();
$tokenService = new TokenService($db, $config['app']['token_ttl_minutes']);
$authMiddleware = new AuthMiddleware($db, $tokenService);
$authController = new AuthController($db, $tokenService);
$entryController = new EntryController($db);

// Enable CORS for Flutter app
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

// Handle preflight requests
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

// Get request path and method
$method = $_SERVER['REQUEST_METHOD'];
$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$path = rtrim($path, '/');

// Remove /api prefix if present
if (strpos($path, '/api') === 0) {
    $path = substr($path, 4);
}
$path = $path ?: '/';

// Route handling
try {
    // Auth routes
    if ($path === '/auth/register' && $method === 'POST') {
        $authController->register();
        exit;
    }

    if ($path === '/auth/login' && $method === 'POST') {
        $authController->login();
        exit;
    }

    if ($path === '/auth/profile' && $method === 'GET') {
        $user = $authMiddleware->requireUser();
        if ($user) {
            $authController->profile($user);
        }
        exit;
    }

    // Entry routes
    if ($path === '/entries' && $method === 'GET') {
        $entryController->list();
        exit;
    }

    if (preg_match('/^\/entries\/(\d+)$/', $path, $matches) && $method === 'GET') {
        $entryController->show((int) $matches[1]);
        exit;
    }

    if ($path === '/entries' && $method === 'POST') {
        $user = $authMiddleware->requireUser();
        if ($user) {
            $entryController->create($user['id']);
        }
        exit;
    }

    if (preg_match('/^\/entries\/(\d+)$/', $path, $matches) && $method === 'PUT') {
        $user = $authMiddleware->requireUser();
        if ($user) {
            $entryController->update((int) $matches[1], $user['id']);
        }
        exit;
    }

    if (preg_match('/^\/entries\/(\d+)$/', $path, $matches) && $method === 'DELETE') {
        $user = $authMiddleware->requireUser();
        if ($user) {
            $entryController->delete((int) $matches[1], $user['id']);
        }
        exit;
    }

    // Like routes
    if (preg_match('/^\/entries\/(\d+)\/like$/', $path, $matches) && $method === 'POST') {
        $user = $authMiddleware->requireUser();
        if ($user) {
            $entryController->like((int) $matches[1], $user['id']);
        }
        exit;
    }

    if (preg_match('/^\/entries\/(\d+)\/like$/', $path, $matches) && $method === 'DELETE') {
        $user = $authMiddleware->requireUser();
        if ($user) {
            $entryController->unlike((int) $matches[1], $user['id']);
        }
        exit;
    }

    // 404 Not Found
    json_response(['message' => 'Not Found'], 404);
} catch (Exception $e) {
    json_response(['message' => 'Internal Server Error', 'error' => $e->getMessage()], 500);
}
