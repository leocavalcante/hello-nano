#!/usr/bin/env php
<?php

declare(strict_types=1);

namespace App;

use App\ExceptionHandler\AppExceptionHandler;
use Dapr\Client\DaprClient;
use GuzzleHttp\Client;
use Hyperf\Contract\ConfigInterface;
use Hyperf\Contract\StdoutLoggerInterface;
use Hyperf\Engine\Contract\Http\V2\ClientFactoryInterface;
use Hyperf\Engine\Contract\Http\V2\ResponseInterface as HyperfResponseInterface;
use Hyperf\ExceptionHandler\ExceptionHandler;
use Hyperf\ExceptionHandler\Handler\WhoopsExceptionHandler;
use Hyperf\Framework\Logger\StdoutLogger;
use Hyperf\Guzzle\ClientFactory;
use Hyperf\HttpMessage\Stream\SwooleStream;
use Hyperf\HttpServer\Contract\RequestInterface;
use Hyperf\Nano\Factory\AppFactory;
use Monolog\Handler\StreamHandler;
use Monolog\Logger;
use Psr\Container\ContainerInterface;
use Psr\Http\Message\ResponseInterface;
use Psr\Log\LoggerInterface;
use Swoole\Coroutine;

use function Hyperf\Support\make;

require_once __DIR__ . '/vendor/autoload.php';

$logger = new Logger('app', [new StreamHandler('php://stdout')]);

$app = AppFactory::createBase(dependencies: [
    LoggerInterface::class => $logger,
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
