#!/usr/bin/env php
<?php

declare(strict_types=1);

use Hyperf\Nano\Factory\AppFactory;

require_once __DIR__ . '/vendor/autoload.php';

$app = AppFactory::createBase(port: 8080);

$app->get('/', function () {
    return 'Hello, Dapr!';
});

$app->run();
