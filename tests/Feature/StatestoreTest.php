<?php

declare(strict_types=1);

namespace Test\Feature;

use GuzzleHttp\Client;
use PHPUnit\Framework\Attributes\CoversClass;
use PHPUnit\Framework\TestCase;

final class StatestoreTest extends TestCase
{
    public function testSaveAndGet(): void
    {
        $http = new Client(['base_uri' => 'http://localhost:3500']);

        $res = $http->get('/v1.0/invoke/hello-nano/method/?key=foo&val=bar');

        self::assertSame(200, $res->getStatusCode());

        $res = $http->get('/v1.0/invoke/hello-nano/method/?key=foo');

        self::assertSame('"bar"', $res->getBody()->getContents());
    }
}
