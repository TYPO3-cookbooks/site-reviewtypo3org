#!/usr/bin/php
<?php

/*
Compatible with Gerrit 2.5, order may change from version to version..
To figure out the input, use
  print_r($_SERVER['argv']);

$argv = array (
 0 => '/var/gerrit/review/hooks/patchset-created',
 1 => '--change',
 2 => 'I7511a12935a6eff29593c0c19c895c625a703ceb',
 3 => '--is-draft',
 4 => 'false',
 5 => '--change-url',
 6 => 'http://review.typo3.org/1307',
 7 => '--project',
 8 => 'FLOW3/Packages/SwiftMailer',
 9 => '--branch',
 10 => 'master',
 11 => '--topic',
 12 => '12345',
 13 => '--uploader',
 14 => 'Karsten Dambekalns (karsten@typo3.org)',
 15 => '--commit',
 16 => 'd8074e04611b5c95ab788b39c9a505329c36964a',
 17 => '--patchset',
 18 => '1',
);
*/

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

// log input parameters
$parametersGiven = array();
foreach ($args as $key => $value) {
    $parametersGiven[] = $key . ':' . $value;
}
echo 'Executing hook file ' . __FILE__ . ' (' . implode(', ', $parametersGiven) . ')';
unset($parametersGiven);


// fetch commit message
$commitInfo = array();
exec('GIT_DIR=/var/gerrit/review/git/' . $args['project'] . '.git/ git show --quiet --pretty=medium ' . $args['commit'], $commitInfo);
$commitInfo = implode($commitInfo, chr(10));

// extract issue footer(s)
$matches = array();
if (preg_match_all('/^\s*(?:Fixes|Resolves): \#([0-9]+)/mi', $commitInfo, $matches) !== FALSE) {
    $issueNumbers = $matches[1];
} else {
    exit(0);
}

ini_set('user_agent', 'Gerrit Hook Script');

foreach ($issueNumbers as $issueId) {
    $existingIssue = json_decode(file_get_contents('http://forge.typo3.org/issues/' . $issueId . '.json'));

    $updatedIssue = array(
        'issue' => array(
            'id' => $issueId,
            'status_id' => '8',
            'notes' => 'Patch set ' . $args['patchset'] . ' for branch *' . $args['branch'] . '* of project *' . $args['project'] . '* has been pushed to the review server.' . chr(10) . 'It is available at ' . $args['change-url']
        )
    );

    putIssue($updatedIssue);
}

function putIssue(array $issue)
{
    $errorNumber = 0;
    $errorMessage = '';
    $fp = fsockopen('tls://forge.typo3.org', 443, $errorNumber, $errorMessage);
    if (!$fp) {
        return $errorNumber . ' - ' . $errorMessage;
    }

    fputs($fp, 'PUT /issues/' . $issue['issue']['id'] . ".json HTTP/1.1\r\n");
    unset($issue['issue']['id']);
    fputs($fp, "Host: forge.typo3.org\r\n");
    // the key belongs to user "gerrit-review"
    fputs($fp, "Authorization: Basic " . base64_encode('<%= @token %>:') . "\r\n");
    fputs($fp, "User-Agent: Gerrit Hook Script\r\n");
    fputs($fp, "Content-Type: application/json\r\n");
    fputs($fp, "Content-Length: " . strlen(json_encode($issue)) . "\r\n");
    fputs($fp, "Connection: close\r\n\r\n");
    fputs($fp, json_encode($issue));
    fputs($fp, "\r\n");

    $result = '';
    while (!feof($fp)) {
        $result .= fgets($fp, 1024);
    }
    fclose($fp);

    return $result;

}
