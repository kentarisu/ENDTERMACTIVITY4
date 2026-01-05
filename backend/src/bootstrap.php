<?php

$config = require __DIR__ . '/../config.php';

spl_autoload_register(function (string $class): void {
    $baseDir = __DIR__ . '/';
    $file = $baseDir . str_replace('\\', '/', $class) . '.php';
    if (file_exists($file)) {
        require_once $file;
    }
});

function json_response(array $data, int $statusCode = 200): void
{
    // Clear any previous output (warnings, errors, etc.) to ensure clean JSON
    // Clean the output buffer if one exists (but don't end it)
    if (ob_get_level() > 0) {
        ob_clean();
    }
    
    http_response_code($statusCode);
    header('Content-Type: application/json; charset=utf-8');
    
    $json = json_encode($data, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    if ($json === false) {
        // If JSON encoding fails, send error
        http_response_code(500);
        $errorJson = json_encode(['message' => 'JSON encoding error', 'error' => json_last_error_msg()]);
        echo $errorJson !== false ? $errorJson : '{"message":"JSON encoding error"}';
    } else {
        echo $json;
    }
}

function parse_json_body(): array
{
    $raw = file_get_contents('php://input');
    if ($raw === false || $raw === '') {
        return [];
    }

    $data = json_decode($raw, true);
    return is_array($data) ? $data : [];
}

