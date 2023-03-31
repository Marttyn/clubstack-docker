<?php

// Fetch method and URI from somewhere
$httpMethod = $_SERVER['REQUEST_METHOD'];
$uri = parse_url($_SERVER['REQUEST_URI']);

if (isset($uri['query'])) {
    parse_str($uri['query'], $uriParams);
    $vars[] = $uriParams;
}
$uri = rawurldecode($uri['path']);

if (isset($dispatcher)) {
    $routeInfo = $dispatcher->dispatch($httpMethod, $uri);

    switch ($routeInfo[0]) {
        case FastRoute\Dispatcher::NOT_FOUND:
            http_response_code(404);
            break;
        case FastRoute\Dispatcher::FOUND:
            $handler = $routeInfo[1];
            $vars[] = $routeInfo[2];
            list($class, $method) = explode("/", $handler, 2);
            call_user_func_array(array(new $class, $method), $vars);
            break;
    }
}
