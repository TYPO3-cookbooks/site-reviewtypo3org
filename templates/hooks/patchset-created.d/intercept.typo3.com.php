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

// do not disclose changes in foreign repositories!
if (
    !strstr($args['project'], 'Packages/TYPO3.CMS')
    && !strstr($args['project'], 'Teams/Security/TYPO3v4-Core')
) {
    echo 'Will not send anything for repositories except Packages/TYPO3.CMS and Teams/Security/TYPO3v4-Core';
    exit;
}

$data = $args;
$data['token'] = '<% @token %>';
$data['changeUrl'] = $data['change-url'];

$url = 'https://intercept.typo3.com/gerrit';

// url-ify the data for the POST
$fields = '';
foreach ($data as $key => $value) {
    $fields .= $key . '=' . urlencode($value) . '&';
}
rtrim($fields, '&');

// open connection
$ch = curl_init();

// set the url, number of POST vars, POST data
curl_setopt($ch, CURLOPT_URL, $url);
curl_setopt($ch, CURLOPT_POSTFIELDS, $fields);

// execute post
$result = curl_exec($ch);

// close connection
curl_close($ch);
