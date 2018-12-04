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
		echo "Ignored unexpected parameter #" . $i . ": " . $_SERVER['argv'][$i];
	}
}

// do not disclose changes in foreign repositories!
if (!strstr($args['project'], "Packages/TYPO3.CMS")) {
  echo "Will not send anything for repositories except Packages/TYPO3.CMS";
  exit;
}

// fetch commit message
/*$commitInfo = '';
exec('GIT_DIR=/var/gerrit/review/git/' . $args['project'] . '.git/ git log -1 --quiet --pretty=medium ' . $args['commit'], $commitInfo);
$commitInfo = implode($commitInfo, chr(10));*/

$data = $args;
//$data['message'] = $commitInfo;
$data['token'] = "<% @token %>";
$data['changeUrl'] = $data['change-url'];
$fields = $data;

$url = 'https://intercept.typo3.com/gerrit';

//url-ify the data for the POST
$fields_string = '';
foreach($fields as $key=>$value) { $fields_string .= $key . '=' . urlencode($value) . '&'; }
rtrim($fields_string, '&');

//open connection
$ch = curl_init();

//set the url, number of POST vars, POST data
curl_setopt($ch,CURLOPT_URL, $url);
curl_setopt($ch,CURLOPT_POST, count($fields));
curl_setopt($ch,CURLOPT_POSTFIELDS, $fields_string);

//execute post
$result = curl_exec($ch);

//close connection
curl_close($ch);
