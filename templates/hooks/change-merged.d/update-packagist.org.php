#!/usr/bin/php
<?php

// Manual usage:
// php update-packagist.org.php --project TYPO3CMS/Extensions/rss_display --branch master

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


// Hook into Packagist
exec('GIT_DIR=/var/gerrit/review/git/' . $args['project'] . '.git/ git cat-file blob ' . $args['branch'] . ':composer.json', $composerJson, $result);
if ($result === 0 && !empty($composerJson)) {
    $composerJson = json_decode(implode('', $composerJson));
    if (is_object($composerJson) && !empty($composerJson->name)) {

        // We have a composer.json in our branch, check for packagist package to update
        $http = curl_init('https://packagist.org/packages/' . $composerJson->name);
        curl_setopt($http, CURLOPT_RETURNTRANSFER, TRUE);
        $result = curl_exec($http);
        $http_status = curl_getinfo($http, CURLINFO_HTTP_CODE);
        curl_close($http);
        if ($http_status === 200) {

            // Package is found on packagist, request an update
            $url = sprintf('curl -X PUT -d username=%s -d apiToken=%s -d update=1 --silent https://packagist.org/packages/%s',
                'typo3', // Packagist username
                '<%= @token %>', // API Token
                $composerJson->name
            );

            exec($url, $result);

            $message = 'something unexpected went wrong';
            if (!empty($result)) {
                $message = implode("\n", $result);
            }
            echo chr(10);
            echo 'Update ' . $composerJson->name . ' on packagist.org returned: ' . $message;
            echo chr(10);
        }
    }
}
