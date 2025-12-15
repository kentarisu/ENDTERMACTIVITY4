<?php

class Database
{
    private static ?PDO $instance = null;

    public static function connection(): PDO
    {
        if (self::$instance === null) {
            $config = require __DIR__ . '/../config.php';
            $dsn = sprintf(
                'mysql:host=%s;port=%s;dbname=%s;charset=%s',
                $config['db']['host'],
                $config['db']['port'],
                $config['db']['name'],
                $config['db']['charset']
            );

            self::$instance = new PDO(
                $dsn,
                $config['db']['user'],
                $config['db']['pass'],
                [
                    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                ]
            );
        }

        return self::$instance;
    }
}

