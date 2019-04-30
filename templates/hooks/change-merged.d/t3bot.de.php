#!/usr/bin/php
<?php

// parse parameters into sth. easier to access, namely into $args
$args = array();
for ($i = 1; $i < $_SERVER['argc']; $i++) {
    if (substr($_SERVER['argv'][$i], 0, 2) == '--') {
        $optionName = substr($_SERVER['argv'][$i], 2);
        $args[$optionName] = $_SERVER['argv'][$i + 1];
        $i++;
    } else {
        echo 'Ignored unexpected parameter #' . $i . ': ' . $_SERVER['argv'][$i];
    }
}

// do not disclose changes in security repositories!
if (strstr($args['project'], 'Teams/Security/')) {
    echo 'Will not send anything for repositories below Teams/Security/';
    exit;
}

// fetch commit message
$commitInfo = array();
exec('GIT_DIR=/var/gerrit/review/git/' . $args['project'] . '.git/ git log -1 --quiet --pretty=medium ' . $args['commit'], $commitInfo);
$commitInfo = implode($commitInfo, chr(10));

$data = $args;
$data['message'] = $commitInfo;
$data['token'] = '<%= @token %>';

$urls = array(
    'https://stage.t3bot.de/hooks/gerrit/?action=' . $data['action'],
    'https://www.t3bot.de/hooks/gerrit/?action=' . $data['action'],
);

$options = array(
    'http' => array(
        'header' => 'Content-type: application/json',
        'method' => 'POST',
        'content' => json_encode($data),
        'ignore_errors' => true,
    ),
);

$context = stream_context_create($options);

foreach ($urls as $url) {
    $result = file_get_contents($url, false, $context);
    echo 'Request to ' . $url . ' returned ' . $http_response_header[0] . "\n";
}
