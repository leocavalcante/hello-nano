<?php

declare(strict_types=1);

namespace App\ExceptionHandler;

use Hyperf\Codec\Json;
use Hyperf\ExceptionHandler\ExceptionHandler;
use Hyperf\HttpMessage\Stream\SwooleStream;
use PHPUnit\Event\Code\Throwable;
use Psr\Http\Message\ResponseInterface;
use Psr\Log\LoggerInterface;

final class AppExceptionHandler extends ExceptionHandler
{
    public function __construct(
        private LoggerInterface $logger,
    ) {}

    public function handle(\Throwable $throwable, ResponseInterface $response)
    {
        $this->logger->error($throwable->getMessage(), ['exception' => $throwable]);

        $body = Json::encode([
            'error' => true,
            'message' => $throwable->getMessage(),
        ]);

        return $response
            ->withStatus(500)
            ->withHeader('Content-Type', 'application/json')
            ->withBody(new SwooleStream($body));
    }

    public function isValid(\Throwable $throwable): bool
    {
        return true;
    }
}
