#!/usr/bin/env php
<?php

declare(strict_types=1);

use Dapr\Client\DaprClient;
use Hyperf\Nano\Factory\AppFactory;
use Swoole\Coroutine;

require_once __DIR__ . '/vendor/autoload.php';

Coroutine::set(['hook_flags' => SWOOLE_HOOK_ALL]);

$dapr = DaprClient::clientBuilder()->build();
$app = AppFactory::createBase();

$app->get('/', function () use ($dapr) {
    $dapr->saveState('statestore', 'key', 'Hello, Dapr!');
    return 'Hello, Dapr!';
});

$app->run();
