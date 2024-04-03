#!/usr/bin/env php
<?php

declare(strict_types=1);

use App\ExceptionHandler\AppExceptionHandler;
use GuzzleHttp\Client;
use Hyperf\Guzzle\ClientFactory;
use Hyperf\HttpServer\Contract\RequestInterface;
use Hyperf\Nano\Factory\AppFactory;
use Monolog\Handler\StreamHandler;
use Monolog\Logger;
use Psr\Container\ContainerInterface;
use Psr\Log\LoggerInterface;

require_once __DIR__ . '/vendor/autoload.php';

$logger = new Logger('app', [new StreamHandler('php://stdout')]);

$app = AppFactory::createBase(dependencies: [
    LoggerInterface::class => static fn(ContainerInterface $container): Logger => $logger,
]);

$app->addExceptionHandler(AppExceptionHandler::class);

$app->get('/', function (RequestInterface $request, ClientFactory $clientFactory) use ($logger): string  {
    /** @var Client $dapr */
    $dapr = $clientFactory->create([
        'base_uri' => 'http://127.0.0.1:3500',
    ]);

    $key = $request->query('key', '');
    $val = $request->query('val', '');

    if ($val === '') {
        $response = $dapr->get("/v1.0/state/statestore/{$key}");
        return $response->getBody()->getContents();    
    }

    $response = $dapr->post('/v1.0/state/statestore', [
        'json' => [[
            'key' => $key,
            'value' => $val,
        ]],
    ]);

    return $response->getBody()->getContents();    
});

$app->run();
